module AresMUSH
  module Pose
    class Pose
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def want_command?(cmd)
        cmd.logged_in? && cmd.root_is?("pose")
      end
      
      def on_command(client, cmd)
        @client_monitor.emit_all Formatter.parse_pose(client.name, ":#{cmd.args}")
      end
    end
  end
end
