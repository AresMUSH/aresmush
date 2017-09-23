module AresMUSH
  module Pose
    class SetPoseCmd
      include CommandHandler
      
      attr_accessor :pose
      
      def parse_args
        self.pose = cmd.args
      end
      
      def handle        
        enactor.room.characters.each do |char|
          client = char.client
          next if !client
        
          formatted_pose = Pose.custom_format(self.pose, char, enactor, true, false)
          line = "%R%xh%xc%% #{'-'.repeat(75)}%xn%R"
          client.emit "#{line}%R#{formatted_pose}%R#{line}"
        end
        Global.dispatcher.queue_event PoseEvent.new(enactor, self.pose, true, true)          
      end
      
      def log_command
        # Don't log poses
      end
    end
  end
end
