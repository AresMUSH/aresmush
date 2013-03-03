module AresMUSH
  module Rooms
    class LoginEvents
      include AresMUSH::Plugin
    
      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def on_player_connected(args)
        client = args[:client]
        Rooms.emit_current_desc(client)
        client.emit_to_location(t('rooms.announce_player_arrived', :name => client.name))
      end
      
      def on_player_created(args)
        client = args[:client]
        set_starting_location(client)
        Rooms.emit_current_desc(client)
        client.emit_to_location(t('rooms.announce_player_arrived', :name => client.name))
      end
      
      def set_starting_location(client)
        # Set their starting location
        game = Game.get
        welcome_room = game['rooms']['welcome_id']
        client.player["location"] = welcome_room
        Player.update(client.player)
      end
    end
  end
end
