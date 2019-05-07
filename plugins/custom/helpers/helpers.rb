module AresMUSH
  module Custom
    def self.channel_alert(message)
      channel = Global.read_config("custom", "alert_channel")
      if (channel)
        Channels.send_to_channel(channel, message)
      end
    end
  end
end
