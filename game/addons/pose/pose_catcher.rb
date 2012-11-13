module AresMUSH
  module Pase
    class PoseCatcher
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def commands
        { :all => "" }
      end
      
      def on_player_command(client, cmd)
        @client_monitor.tell_all client.player.parse_pose(cmd.to_s)
      end
    end
  end
end
