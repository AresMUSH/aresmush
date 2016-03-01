module AresMUSH
  module Rooms
    class GridCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches

      attr_accessor :x, :y
      
      def want_command?(client, cmd)
        cmd.root_is?("grid")
      end
            
      def crack!
        if (cmd.args.nil?)
          self.x = nil
          self.y = nil
        else
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.x = trim_input(cmd.args.arg1)
          self.y = trim_input(cmd.args.arg2)
        end
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end
      
      def handle
        if (self.x.nil? || self.y.nil?)
          client.room.grid_x = nil
          client.room.grid_y = nil
          message = t('rooms.grid_cleared')
        else          
          client.room.grid_x = self.x
          client.room.grid_y = self.y
          message = t('rooms.grid_set')
        end
        client.room.save!
        client.emit_success message
      end
    end
  end
end
