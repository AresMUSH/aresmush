module AresMUSH
  module Pose
    class SetPoseCmd
      include CommandHandler
      
      attr_accessor :pose
      
      def parse_args
        self.pose = cmd.args
      end
      
      def handle
        
        Global.client_monitor.logged_in.each do |client, char|
          next if char.room != enactor.room
          formatted_pose = Pose.custom_format(self.pose, char, enactor, true, false)
          line = "%R%xh%xc%% ----------------------%xn%R"
          client.emit "#{line}%R#{pose}%R#{line}"
          
          Global.dispatcher.queue_event PoseEvent.new(enactor, formatted_pose, true, true)          
        end
      end
      
      def log_command
        # Don't log poses
      end
    end
  end
end
