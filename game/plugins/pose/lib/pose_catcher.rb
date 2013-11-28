module AresMUSH
  module Pose
    class PoseCatcher
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def want_command?(cmd)
        cmd.logged_in? && 
        (cmd.raw.start_with?("\"") ||
         cmd.raw.start_with?("\\") ||
         cmd.raw.start_with?(":") ||
         cmd.raw.start_with?(";"))
      end
      
      def on_command(client, cmd)
        @client_monitor.emit_all Formatter.parse_pose(client.name, cmd.raw)
      end
    end
  end
end
