module AresMUSH
  module Pose
    class Pose
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def commands
        { "pose" => "pose (?<msg>.+)" }
      end
      
      def on_command(client, cmd)
        @client_monitor.tell_all client.player.parse_pose("\:#{cmd[:msg]}")
      end
    end
  end
end
