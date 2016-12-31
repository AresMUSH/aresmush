module AresMUSH
  module Rooms
    class OpenCmd
      include CommandHandler

      attr_accessor :name
      attr_accessor :dest
        
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.name = cmd.args.arg1
        self.dest = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'open'
        }
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        dest = nil
        if (self.dest)
          find_result = ClassTargetFinder.find(self.dest, Room, enactor)
          if (!find_result.found?)
            client.emit_failure(find_result.error)
            return
          end
          dest = find_result.target
        end
        client.emit_success Rooms.open_exit(self.name, enactor_room, dest)
      end
    end
  end
end
