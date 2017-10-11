module AresMUSH
  module Channels
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        
        Channels.add_to_default_channels(client, char)
        if (client)
          client.emit_success t('channels.channel_command_hint')
        end
      end
    end
  end
end
