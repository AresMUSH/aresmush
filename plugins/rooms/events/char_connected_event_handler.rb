module AresMUSH
  module Rooms
    class CharConnectedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        
        # No need to emit room desc for a web connection
        return if !client
        
        Rooms.emit_here_desc(event.client, char)
      end
    end
  end
end
