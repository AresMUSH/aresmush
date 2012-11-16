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
      
      def on_command(client, cmd)
        @client_monitor.tell_all Formatters.parse_pose(cmd.enactor_name, ":#{cmd.args}")
      end
    end
  end
end
