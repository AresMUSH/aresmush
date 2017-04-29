module AresMUSH
  module Channels
    def self.can_manage_channels?(actor)
      actor.has_permission?("manage_channels")
    end
    
    def self.get_channel_options(char, channel)
      char.channel_options.find(channel_id: channel.id).first
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
      intersection = intersection.select { |c| Channels.announce_enabled?(other_char, c) }
      if (intersection.empty?)
        return nil
      end
      intersection = intersection.map { |c| c.display_name(false) }
      Channels.name_with_markers(intersection.join(", "))
    end
    
    def self.announce_enabled?(char, channel)
      options = Channels.get_channel_options(char, channel)
      options ? options.announce : false
    end
    
    def self.name_with_markers(name)
      start_marker = Global.read_config("channels", "start_marker")
      end_marker = Global.read_config("channels", "end_marker")
      "#{start_marker}#{name}%xn#{end_marker}"
    end
    
    def self.is_muted?(char, channel)
      options = Channels.get_channel_options(char, channel)
      options ? options.muted : false
    end
    
    def self.set_muted(char, channel, mute)
      options = Channels.get_channel_options(char, channel)
      options.update(muted: mute)
    end
    
    def self.channel_who(channel)
      chars = channel.characters.sort_by(:name_upcase, :order => "ALPHA")
      online_chars = []
      chars.each do |c|
        next if !c.is_online?
        online_chars << c
      end
      online_chars
    end
    
    def self.mute_text(char, channel)
      Channels.is_muted?(char, channel) ? "%xh%xx#{t('channels.muted')}%xn" : ""
    end
    
    def self.leave_channel(char, channel)
      channel.emit t('channels.left_channel', :name => char.name)
      channel.characters.delete char
    end
    
    def self.channel_for_alias(char, channel_alias)  
      channel_alias = CommandCracker.strip_prefix(channel_alias).downcase    
      char.channel_options.each do |o|
        if (o.match_alias(channel_alias))
          return o.channel
        end
      end
      
      Channel.all.each do |c|
        if (c.name.downcase == channel_alias.downcase)
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
      channel = Channels.channel_for_alias(enactor, name)
      
      if (!channel)
        channel = Channel.find_one_with_partial_match(name)
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
      channel = Channel.find_one_with_partial_match(name)
      
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
          else
            options = Channels.get_channel_options(char, c)
            client.emit_ooc options.alias_hint
          end
        end
      end
    end
    
    def self.set_channel_alias(client, char, channel, chan_alias, warn = true)
      aliases = chan_alias.split(/[, ]/).map { |a| CommandCracker.strip_prefix(a).downcase }
      aliases.each do |a|
        existing_channel = Channels.channel_for_alias(char, a)
        if (existing_channel && existing_channel != channel)
          client.emit_failure t('channels.alias_in_use', :channel_alias => a)
          return false
        end
        
        if (warn && (!a || a.length < 2))
          client.emit_failure t('channels.short_alias_warning')
        end
      end
      
      options = Channels.get_channel_options(char, channel)
      options.update(aliases: aliases)
      
      client.emit_ooc options.alias_hint
      
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
        
        options = Channels.get_channel_options(char, channel)
        if (!options)
          ChannelOptions.create(character: char, channel: channel)
        end
            
        if (!Channels.set_channel_alias(client, char, channel, chan_alias, false))
          client.emit_failure t('channels.unable_to_determine_auto_alias')
          return
        end

        channel.characters << char
        channel.emit t('channels.joined_channel', :name => char.name)
      end
    end
  end
end
