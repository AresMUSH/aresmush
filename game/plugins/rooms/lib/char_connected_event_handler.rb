module AresMUSH
  module Rooms
    class CharConnectedEventHandler
      def on_event(event)
        Rooms.emit_here_desc(event.client, event.char)
      end
    end
  end
end
