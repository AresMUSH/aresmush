module AresMUSH
  module Rooms
    class CharConnectedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        Rooms.emit_here_desc(event.client, char)
      end
    end
  end
end
