module AresMUSH
  module Scenes
    class PoseOrderTypeCmd
      include CommandHandler
      
      attr_accessor :type
      
      def parse_args
        self.type = downcase_arg(cmd.args)
      end
        
      def required_args
        [ self.type ]
      end
      
      def check_type
        types = [ 'normal', '3-per' ]
        return t('scenes.invalid_pose_order_type', :types => types.join(", ")) if !types.include?(self.type)
        return nil
      end
        
      def handle
       enactor_room.update(pose_order_type: self.type)
       enactor_room.emit_ooc t('scenes.pose_order_type_changed', :name => enactor_name, :type => self.type)
      end
    end
  end
end
