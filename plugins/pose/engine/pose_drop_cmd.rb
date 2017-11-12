module AresMUSH
  module Pose
    class PoseDropCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
        
      def required_args
        [ self.name ]
      end
        
      def handle
        
        if (!enactor_room.pose_order.include?(self.name))
          client.emit_failure t('pose.not_in_pose_order', :name => self.name)
          return
        end
        
        enactor_room.remove_from_pose_order(self.name)        
        Rooms.emit_ooc_to_room(enactor_room, t('pose.pose_order_dropped', :name => enactor_name, :dropped => self.name))
        Pose.notify_next_person(enactor_room)
      end
    end
  end
end
