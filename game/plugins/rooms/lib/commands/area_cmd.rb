module AresMUSH
  module Rooms
    class AreaCmd
      include CommandHandler

      attr_accessor :name, :area
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.name = args.arg1
          self.area = titlecase_arg(args.arg2)
        else
          self.name = "here"
          self.area = !cmd.args ? nil : titlecase_arg(cmd.args)
        end
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
      
      def handle
        matched_rooms = Room.find_by_name_and_area self.name, enactor_room
        if (matched_rooms.count != 1)
          client.emit_failure matched_rooms.count == 0 ? t('db.object_not_found') : t('db.object_ambiguous')
          return
        end
        room = matched_rooms.first
        
        if (!self.area)
          room.update(room_area: nil)
          message = t('rooms.area_cleared')
        else
          room.update(room_area: self.area)
          message = t('rooms.area_set', :area => self.area)
        end
        client.emit_success message
      end
    end
  end
end
