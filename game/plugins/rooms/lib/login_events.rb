module AresMUSH
  module Rooms
    class LoginEvents
      include Plugin
    
      def on_char_connected(args)
        client = args[:client]
        Rooms.emit_here_desc(client)
        client.room.emit_ooc t('rooms.char_has_arrived', :name => client.name)
      end
      
      def on_char_disconnected(args)
        client = args[:client]
        if (client.char.has_role?("guest"))
          Rooms.move_to(client, client.char, Game.master.welcome_room)
        end
      end
      
    end
  end
end
