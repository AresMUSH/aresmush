module AresMUSH
  module Rooms
    class OwnerCmd
      include CommandHandler

      attr_accessor :name
      
      def parse_args
        self.name = !cmd.args ? nil : titlecase_arg(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        if (!self.name)
          enactor_room.update(room_owner: nil)
          client.emit_success t('rooms.owner_cleared')
        else
          ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
            enactor_room.update(room_owner: model.id)
            client.emit_success t('rooms.owner_set')
          end
        end
      end
    end
  end
end
