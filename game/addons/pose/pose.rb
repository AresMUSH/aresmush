module AresMUSH
  module Pose
    class Pose
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def want_command?(cmd)
        cmd.root_is?("pose")
      end
      
      def on_command(cmd)
        @client_monitor.tell_all cmd.client.parse_pose(":#{cmd.args}")
      end
    end
  end
end
