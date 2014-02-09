module AresMUSH
  module Rooms
    class LoginEvents
      include AresMUSH::Plugin
    
      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def on_char_connected(args)
        client = args[:client]
        emit_here_desc(client)
        Rooms.room_emit(client.room, t('rooms.announce_char_arrived', :name => client.name), @client_monitor.clients)
      end
      
      def emit_here_desc(client)        
        room = client.char.room
        desc = room.nil? ? "" : Describe.get_desc(room)
        client.emit(desc)
      end
    end
  end
end
