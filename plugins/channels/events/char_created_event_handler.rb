module AresMUSH
  module Channels
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        
        Channels.add_to_default_channels(char, client)
      end
    end
  end
end
