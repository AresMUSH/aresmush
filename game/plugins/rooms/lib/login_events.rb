module AresMUSH
  module Rooms
    class LoginEvents
      include AresMUSH::Plugin
    
      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def on_char_connected(args)
        client = args[:client]
        emit_here_desc(client)
        Rooms.room_emit(client.location, t('rooms.announce_char_arrived', :name => client.name), @client_monitor.clients)
      end
      
      def on_char_created(args)
        client = args[:client]
        set_starting_location(client)
        emit_here_desc(client)
        Rooms.room_emit(client.location, t('rooms.announce_char_arrived', :name => client.name), @client_monitor.clients)
      end
      
      def set_starting_location(client)
        game = Game.get
        welcome_room = game['rooms']['welcome_id']
        client.char["location"] = welcome_room
        Character.update(client.char)
      end
      
      def emit_here_desc(client)
        loc = client.location
        room = Room.find_by_id(loc)
        desc = room.empty? ? "" : Describe.get_desc(room[0])
        client.emit(desc)
      end
    end
  end
end
