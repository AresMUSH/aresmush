module AresMUSH
  module Channels
    class CharApprovedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
                
        channels = Global.read_config("channels", "approved_channels")          
        Channels.add_to_channels(client, char, channels)
        
        if (client)
          client.emit_success t('channels.channel_command_hint')
        end
      end
    end
  end
end
