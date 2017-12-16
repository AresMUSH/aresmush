module AresMUSH
  module Pose
    class SetPoseCmd
      include CommandHandler
      
      attr_accessor :pose
      
      def parse_args
        self.pose = cmd.args
      end
      
      def handle        
        Pose.emit_setpose(enactor, self.pose)
      end
      
      def log_command
        # Don't log poses
      end
    end
  end
end
