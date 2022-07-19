module AresMUSH
  module Rooms
    class CharDisconnectedEventHandler      
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        if (char.is_guest?)
          
          # This has nothing to do with rooms, but there's no better place to put it.
          char.update(screen_reader: false)
          char.update(color_mode: "FANSI")
          
          Rooms.move_to(client, char, Game.master.welcome_room)
        end
      end  
    end
  end
end
