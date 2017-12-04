module AresMUSH
  module Pose
    class SetPoseCmd
      include CommandHandler
      
      attr_accessor :pose
      
      def parse_args
        self.pose = cmd.args
      end
      
      def handle        
        line = "%R%xh%xc%% #{'-'.repeat(75)}%xn%R"
        message = "#{line}%R#{self.pose}%R#{line}"
        Pose.emit_pose(enactor, message, true, false)
      end
      
      def log_command
        # Don't log poses
      end
    end
  end
end
