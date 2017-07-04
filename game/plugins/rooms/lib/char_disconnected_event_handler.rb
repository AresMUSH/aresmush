module AresMUSH
  module Rooms
    class CharDisconnectedEventHandler      
      def on_event(event)
        client = event.client
        if (event.char.is_guest?)
          Rooms.move_to(client, event.char, Game.master.welcome_room)
        end
      end  
    end
  end
end
