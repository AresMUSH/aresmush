module AresMUSH
  module Rooms
    class OpenCmd
      include CommandHandler

      attr_accessor :name
      attr_accessor :dest
        
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = trim_arg(args.arg1)
        self.dest = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        room = nil
        if (self.dest)
          find_result = Rooms.find_single_room(self.dest, enactor)
          if (find_result[:error])
            client.emit_failure find_result[:error]
            return
          end
          room = find_result[:room]
        end
        client.emit_success Rooms.open_exit(self.name, enactor_room, room)
      end
    end
  end
end
