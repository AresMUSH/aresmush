module AresMUSH
  module Pose
    class PoseCatcherCmd
      include CommandHandler
      include CommandRequiresLogin
           
      def handle
        message = PoseFormatter.format(client.name, cmd.raw)
        Pose.emit_pose(client, message, cmd.raw.start_with?("\\"), false)
      end

      def log_command
        # Don't log poses
      end 
    end
  end
end
