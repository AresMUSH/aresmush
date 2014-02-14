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
      
      def handle
        room = client.room
        room.emit PoseFormatter.format(client.name, cmd.raw)
      end

      def log_command
        # Don't log poses
      end      
    end
  end
end
