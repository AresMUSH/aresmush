module AresMUSH
  module Pose
    class PoseCatcherCmd
      include CommandHandler
           
      def handle
        message = PoseFormatter.format(enactor_name, cmd.raw)
        Pose.emit_pose(enactor, message, cmd.raw.start_with?("\\"), false)
      end

      def log_command
        # Don't log poses
      end 
    end
  end
end
