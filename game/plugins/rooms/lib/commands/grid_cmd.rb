module AresMUSH
  module Rooms
    class GridCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches

      attr_accessor :x, :y
      
      def crack!
        if (!cmd.args)
          self.x = nil
          self.y = nil
        else
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.x = trim_input(cmd.args.arg1)
          self.y = trim_input(cmd.args.arg2)
        end
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        if (!self.x || !self.y)
          enactor_room.grid_x = nil
          enactor_room.grid_y = nil
          message = t('rooms.grid_cleared')
        else          
          enactor_room.grid_x = self.x
          enactor_room.grid_y = self.y
          message = t('rooms.grid_set')
        end
        enactor_room.save
        client.emit_success message
      end
    end
  end
end
