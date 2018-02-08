module AresMUSH
  module Rooms
    class RoomTypeCmd
      include CommandHandler

      attr_accessor :name, :roomtype
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = args.arg1
          self.roomtype = args.arg2 ? args.arg2.upcase : nil
        else
          self.name = "here"
          self.roomtype = cmd.args ? cmd.args.upcase : nil
        end
      end
      
      def required_args
        [ self.name, self.roomtype ]
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def check_room_type
        return nil if !self.roomtype
        return t('rooms.invalid_room_type', :types => Rooms.room_types.join(", ")) if !Rooms.room_types.include?(self.roomtype)
        return nil
      end
      
      def handle
        matched_rooms = Room.find_by_name_and_area self.name, enactor_room
        if (matched_rooms.count != 1)
          client.emit_failure matched_rooms.count == 0 ? t('db.object_not_found') : t('db.object_ambiguous')
          return
        end
        room = matched_rooms.first
        
        room.update(room_type: self.roomtype)
        client.emit_success t('rooms.room_type_set')
      end
    end
  end
end
