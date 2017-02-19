module AresMUSH
  module Rooms
    class GridCmd
      include CommandHandler

      attr_accessor :x, :y
      
      def parse_args
        if (!cmd.args)
          self.x = nil
          self.y = nil
        else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.x = trim_arg(args.arg1)
          self.y = trim_arg(args.arg2)
        end
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        if (!self.x || !self.y)
          enactor_room.update(room_grid_x: nil)
          enactor_room.update(room_grid_y: nil)
          message = t('rooms.grid_cleared')
        else          
          enactor_room.update(room_grid_x: self.x)
          enactor_room.update(room_grid_y: self.y)
          message = t('rooms.grid_set')
        end
        client.emit_success message
      end
    end
  end
end
