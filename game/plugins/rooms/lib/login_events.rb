module AresMUSH
  module Rooms
    class LoginEvents
      include AresMUSH::Plugin
    
      def on_char_connected(args)
        client = args[:client]
        emit_here_desc(client)
        client.room.emit_ooc t('rooms.announce_char_arrived', :name => client.name)
      end
      
      def emit_here_desc(client)        
        desc = Describe.get_desc(client.room)
        client.emit(desc)
      end
    end
  end
end
