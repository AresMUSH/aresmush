module AresMUSH
  module Rooms
    class LoginEvents
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def on_player_connected(args)
        foo(args[:client])
      end
      
      def on_player_created(args)
        game = Game.get
        welcome_room = game['rooms']['welcome_id']
        foo(args[:client])
      end

      def foo(client)
        room = Room.find_by_id(client.player["location"])
        # TODO - nil
        if (room.empty?)
          client.emit_failure("Can't find that room.")
          return
        end
        
        room = room[0]
        client.emit_with_lines Describe.room_desc(room)
      end
    end
  end
end
