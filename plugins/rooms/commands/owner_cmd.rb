module AresMUSH
  module Rooms
    class OwnerCmd
      include CommandHandler

      attr_accessor :name, :owner_name
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.name = args.arg1
          self.owner_name = titlecase_arg(args.arg2)
        else
          self.name = "here"
          self.owner_name = !cmd.args ? nil : titlecase_arg(cmd.args)
        end
      end

      def required_args
        [ self.name ]
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
        
        if (!self.owner_name)
          room.update(room_owner: nil)
          client.emit_success t('rooms.owner_cleared')
        else
          ClassTargetFinder.with_a_character(self.owner_name, client, enactor) do |model|
            room.update(room_owner: model.id)
            client.emit_success t('rooms.owner_set')
          end
        end
      end
    end
  end
end