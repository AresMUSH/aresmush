module AresMUSH
  module Scenes
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
        if (!enactor_room.pose_order.keys.map { |k, v| k.titlecase }.include?(self.name))
          client.emit_failure t('scenes.not_in_pose_order', :name => self.name)
          return
        end
        
        Scenes.remove_from_pose_order(enactor, self.name, enactor_room)
      end
    end
  end
end
