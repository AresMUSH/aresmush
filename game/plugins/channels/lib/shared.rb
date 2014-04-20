module AresMUSH
  module Channels
    def self.can_manage_channels?(actor)
      return actor.has_any_role?(Global.config["channels"]["roles"]["can_manage_channels"])
    end

    def self.can_change_channels?(actor)
      return actor.has_any_role?(Global.config["channels"]["roles"]["can_change_channels"])
    end
    
    def self.set_channel_option(char, channel, option, value)
      channel_options = char.channel_options[channel.name]
      if (channel_options.nil?)
        char.channel_options[channel.name] = { option => value }
      else
        char.channel_options[channel.name][option] = value
      end
    end
    
    def self.get_channel_option(char, channel, option)
      channel_options = char.channel_options[channel.name]
      channel_options.nil? ? nil : channel_options[option]
    end
    
    def self.name_with_markers(name)
      start_marker = Global.config['channels']['start_marker']
      end_marker = Global.config['channels']['end_marker']
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
      chars = chars.map { |c| "#{c.name}#{gag_text(c, channel)}" }
      t('channels.channel_who', :name => channel.display_name, :chars => chars.join(", "))
    end
    
    def self.gag_text(char, channel)
      Channels.is_gagging?(char, channel) ? t('channels.gagging') : ""
    end
    
    def self.leave_channel(char, channel)
      channel.emit t('channels.left_channel', :name => char.name)
      channel.characters.delete char
      channel.save!
    end
    
    def self.channel_for_alias(char, channel_alias)
      char.channel_options.keys.each do |k|
        if (char.channel_options[k]["alias"] == channel_alias)
          return Channel.find_by_name(k)
        end
      end
      return nil
    end
    
    def self.can_use_channel(char, channel)
      return true if channel.roles.empty?
      return char.has_any_role?(channel.roles)
    end
  end
end
