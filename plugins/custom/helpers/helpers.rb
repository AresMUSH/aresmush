module AresMUSH
  module Custom
    def self.channel_alert(message)
      channel = Global.read_config("custom", "alert_channel")
      if (channel)
        Channels.send_to_channel(channel, message)
      end
    end
    def wrap(length = 78, character = $/)
      scan(/.{#{length}}|.+/).map { |x| x.strip }.join(character)
    end
  end
end
