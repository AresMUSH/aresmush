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
          matched_rooms = Room.find_by_name_and_area self.dest
          if (matched_rooms.count != 1)
            client.emit_failure matched_rooms.count == 0 ? t('db.object_not_found') : t('db.object_ambiguous')
            return
          end
          room = matched_rooms.first
        end
        client.emit_success Rooms.open_exit(self.name, enactor_room, room)
      end
    end
  end
end
