module AresMUSH
  module Rooms
    class LoginEvents
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def on_player_connected(args)
        client = args[:client]
        emit_room_desc(client)
      end
      
      def on_player_created(args)
        client = args[:client]
        
        # Set their starting location
        game = Game.get
        welcome_room = game['rooms']['welcome_id']
        client.player["location"] = welcome_room
        Player.update(client.player)
        
        emit_room_desc(client)
      end
      
      def emit_room_desc(client)
        loc = client.player["location"]
        room = Room.find_by_id(loc)
        client.emit_with_lines Describe.room_desc(room[0])
      end
      
    end
  end
end
