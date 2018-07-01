module AresMUSH
  module Rooms
    class RoomAreaCmd
      include CommandHandler

      attr_accessor :room_name, :area_name
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.room_name = args.arg1
          self.area_name = titlecase_arg(args.arg2)
        else
          self.room_name = "here"
          self.area_name = !cmd.args ? nil : titlecase_arg(cmd.args)
        end
      end

      def required_args
        [ self.room_name ]
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        matched_rooms = Room.find_by_name_and_area self.room_name, enactor_room
        if (matched_rooms.count != 1)
          client.emit_failure matched_rooms.count == 0 ? t('db.object_not_found') : t('db.object_ambiguous')
          return
        end
        room = matched_rooms.first
        
        if (!self.area_name)
          room.update(area: nil)
          message = t('rooms.area_cleared')
        else
          area = Area.find_one_by_name(self.area_name)
          if (!area)
            client.emit_ooc t('rooms.area_not_found_creating', :area => self.area_name)
            area = Area.create(name: self.area_name)
          end
          
          room.update(area: area)
          message = t('rooms.area_set', :area => self.area_name)
        end
        client.emit_success message
      end
    end
  end
end
