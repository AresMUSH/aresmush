module AresMUSH
  module Channels
    def self.send_to_channel(channel_name, message)
      channel = Channel.find_one_with_partial_match(channel_name)
      if (!channel)
        Global.logger.error "Tried to send message to non-existent channel #{channel_name}."
        return
      end
      Channels.emit_to_channel channel, message
      Channels.notify_discord_webhook(channel, message, Game.master.system_character)
    end
    
    def self.ooc_lounge_channel
      Global.read_config("channels", "ooc_lounge_channel")
    end
    
    def self.pose_to_channel_if_enabled(channel_name, enactor, message)
      channel = Channel.find_one_with_partial_match(channel_name)
      return false if !channel
      if (!Channels.is_on_channel?(enactor, channel))
        return false
      end
      if (Channels.is_muted?(enactor, channel))
        return false
      end
      options = Channels.get_channel_options(enactor, channel)
      Channels.pose_to_channel channel, enactor, message, options.title
      return true
    end
    
    def self.announce_notification(notification)
      channel_name = Global.read_config("channels", "announce_channel")
      if (!channel_name.blank?)
        Channels.send_to_channel(channel_name, notification)
      end
    end
  end
end