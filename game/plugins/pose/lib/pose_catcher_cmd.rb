module AresMUSH
  module Pose
    class PoseCatcher
      include CommandHandler
      include CommandRequiresLogin
      
      def want_command?(client, cmd)
        cmd.raw.start_with?("\"") ||
        cmd.raw.start_with?("\\") ||
        cmd.raw.start_with?(":") ||
        cmd.raw.start_with?(";")
      end
      
      def handle
        message = PoseFormatter.format(client.name, cmd.raw)
        Pose.emit_pose(client, message, cmd.raw.start_with?("\\"))
      end

      def log_command
        # Don't log poses
      end 
    end
  end
end
