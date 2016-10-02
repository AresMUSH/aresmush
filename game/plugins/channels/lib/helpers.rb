module AresMUSH
  module Channels
    def self.can_manage_channels?(actor)
      return actor.has_any_role?(Global.read_config("channels", "roles", "can_manage_channels"))
    end

    def self.set_channel_option(char, channel, option, value)
      channel_options = char.channel_options[channel.name]
      if (!channel_options)
        char.channel_options[channel.name] = { option => value }
      else
        char.channel_options[channel.name][option] = value
      end
    end
    
    def self.get_channel_option(char, channel, option)
      channel_options = char.channel_options[channel.name]
      !channel_options ? nil : channel_options[option]
    end
 
    def self.is_talk_cmd(enactor, cmd)
      return false if !enactor
      return false if !cmd.args    
      channel = Channels.channel_for_alias(enactor, cmd.root)
      channel
    end
    
    def self.find_common_channels(channels, other_char)
      their_channels = other_char.channels
      intersection = channels.to_a & their_channels.to_a
      intersection = intersection.select { |c| c.announce }
      if (intersection.empty?)
        return nil
      end
      intersection = intersection.map { |c| c.display_name(false) }
      Channels.name_with_markers(intersection.join(", "))
    end
    
    
    def self.name_with_markers(name)
      start_marker = Global.read_config("channels", "start_marker")
      end_marker = Global.read_config("channels", "end_marker")
      "#{start_marker}#{name}%xn#{end_marker}"
    end
    
    def self.is_gagging?(char, channel)
      Channels.get_channel_option(char, channel, "gagging")
    end
    
    def self.set_gagging(char, channel, gag)
      Channels.set_channel_option(char, channel, "gagging", gag)
    end
    
    def self.channel_who(channel)
      chars = channel.characters.sort { |c1, c2| c1.name <=> c2.name }
      online_chars = []
      chars.each do |c|
        next if !c.is_online?
        online_chars << c
      end
      online_chars
    end
    
    def self.gag_text(char, channel)
      Channels.is_gagging?(char, channel) ? t('channels.gagging') : ""
    end
    
    def self.leave_channel(char, channel)
      channel.emit t('channels.left_channel', :name => char.name)
      channel.characters.delete char
      channel.save
    end
    
    def self.channel_for_alias(char, channel_alias)
      a2 = CommandCracker.strip_prefix(channel_alias)
      
      char.channel_options.keys.each do |k|
        option_aliases = char.channel_options[k]["alias"]
        return nil if !option_aliases
        
        option_aliases.each do |a1|
          if (CommandCracker.strip_prefix(a1).downcase == a2.downcase)
            return Channel.find_one(k)
          end
        end
      end
      
      Channel.all.each do |c|
        if (c.name.downcase == a2)
          return c
        end
      end
      return nil
    end
    
    def self.can_use_channel(char, channel)
      return true if channel.roles.empty?
      return char.has_any_role?(channel.roles)
    end
    
    def self.with_an_enabled_channel(name, client, enactor, &block)
      channel = Channel.find_one(name)
      
      if (!channel)
        channel = Channels.channel_for_alias(enactor, name)
      end
      
      if (!channel)
        client.emit_failure t('channels.channel_doesnt_exist', :name => name) 
        return
      end

      if (!Channels.is_on_channel?(enactor, channel))
        client.emit_failure t('channels.not_on_channel')
        return
      end
      
      yield channel
    end
    
    def self.with_a_channel(name, client, &block)
      channel = Channel.find_one(name)
      
      if (!channel)
        client.emit_failure t('channels.channel_doesnt_exist', :name => name) 
        return
      end
      
      yield channel
    end
    
    def self.is_on_channel?(char, channel)
      channel.characters.include?(char)
    end
    
    def self.add_to_default_channels(client, char)
      channels = Global.read_config("channels", "default_channels")
      channels.each do |name|
        Channels.with_a_channel(name, client) do |c|
          if (!Channels.is_on_channel?(char, c))
            Channels.join_channel(name, client, char, nil)
          end
        end
      end
    end
    
    def self.set_channel_alias(client, char, channel, chan_alias, warn = true)
      aliases = chan_alias.split(/[, ]/)
      aliases.each do |a|
        existing_channel = Channels.channel_for_alias(char, a)
        if (existing_channel && existing_channel != channel)
          client.emit_failure t('channels.alias_in_use', :channel_alias => a)
          return false
        end
        
        trimmed_alias = CommandCracker.strip_prefix(a)
        if (warn && (!trimmed_alias || trimmed_alias.length < 2))
          client.emit_failure t('channels.short_alias_warning')
        end
      end
      
      Channels.set_channel_option(char, channel, "alias", aliases)
      
      aliases.each do |a|
        client.emit_success t('channels.channel_alias_set', :name => channel.name, :channel_alias => a)
      end
      
      char.save
      return true
    end
    
    def self.join_channel(name, client, char, chan_alias)
      Channels.with_a_channel(name, client) do |channel|
                
        if (Channels.is_on_channel?(char, channel))
          client.emit_failure t('channels.already_on_channel')
          return
        end
        
        if (!Channels.can_use_channel(char, channel))
          client.emit_failure t('channels.cant_use_channel')
          return
        end
        
        if (!chan_alias)
          chan_alias = channel.default_alias.join(",")
        end
            
        if (!Channels.set_channel_alias(client, char, channel, chan_alias, false))
          client.emit_failure t('channels.unable_to_determine_auto_alias')
          return
        end

        channel.characters << char
        channel.save
        channel.emit t('channels.joined_channel', :name => char.name)
      end
    end
  end
end
