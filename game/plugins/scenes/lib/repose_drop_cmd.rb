module AresMUSH
  module Scenes
    class ReposeDropCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
        
      def required_args
        {
          args: [ self.name ],
          help: 'repose'
        }
      end
        
      def handle
        
        if (!enactor.room.repose_on?)
          client.emit_failure t('pose.repose_off')
          return
        end
        
        order = enactor_room.repose_info.pose_orders.select { |p| p.character.name_upcase == self.name.upcase }.first
        if (!order)
          client.emit_failure t('pose.not_in_pose_order', :name => self.name)
          return
        end
        
        order.delete
        enactor_room.emit_ooc t('pose.pose_order_dropped', :name => enactor_name, :dropped => self.name)
        Pose.notify_next_person(enactor_room)
      end
    end
  end
end
