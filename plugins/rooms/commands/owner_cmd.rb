module AresMUSH
  module Rooms
    class OwnerCmd
      include CommandHandler

      attr_accessor :name, :owner_names
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.name = args.arg1
          self.owner_names = list_arg(args.arg2)
        else
          self.name = "here"
          self.owner_names = !cmd.args ? nil : list(cmd.args)
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
        
        if (!self.owner_names)
          room.room_owners.replace []
          client.emit_success t('rooms.owners_cleared')
        else
          owners = []
          self.owner_names.each do |o|
            char = Character.find_one_by_name(o)
            if (!char)
              client.emit_failure t('db.object_not_found')
              return
            end
            owners << char
          end
          
          room.room_owners.replace owners
          client.emit_success t('rooms.owners_set')
        end
      end
    end
  end
end