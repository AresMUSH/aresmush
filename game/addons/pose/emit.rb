module AresMUSH
  module Pase
    class Emit
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def commands
        { "emit" => "emit (?<msg>.+)" }
      end
      
      def on_player_command(client, cmd)
        @client_monitor.tell_all client.player.parse_pose("\\#{cmd[:msg]}")
      end
    end
  end
end
