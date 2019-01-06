module AresMUSH
  module Channels
    def self.send_to_channel(channel_name, message)
      channel = Channel.find_one_with_partial_match(channel_name)
      if (!channel)
        Global.logger.error "Tried to send message to non-existent channel #{channel_name}."
        return
      end
      Channels.emit_to_channel channel, message  
    end
  end
end