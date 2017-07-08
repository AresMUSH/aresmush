module AresMUSH
  module Rooms
    class RoomTypeCmd
      include CommandHandler

      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'rooms setup'
        }
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def check_room_type
        return nil if !self.name
        return t('rooms.invalid_room_type', :types => Rooms.room_types.join(", ")) if !Rooms.room_types.include?(self.name.upcase)
        return nil
      end
      
      def handle
        room = enactor_room
        room.update(room_type: self.name.upcase)
        Pose.reset_repose(room)
        client.emit_success t('rooms.room_type_set')
      end
    end
  end
end
