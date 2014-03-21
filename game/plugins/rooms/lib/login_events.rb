module AresMUSH
  module Rooms
    class LoginEvents
      include AresMUSH::Plugin
    
      def on_char_connected(args)
        client = args[:client]
        Rooms.emit_here_desc(client)
        client.room.emit_ooc t('rooms.char_has_arrived', :name => client.name)
      end
      
    end
  end
end
