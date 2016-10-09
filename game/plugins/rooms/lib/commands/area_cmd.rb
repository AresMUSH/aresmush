module AresMUSH
  module Rooms
    class AreaCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches

      attr_accessor :name
      
      def crack!
        self.name = !cmd.args ? nil : trim_input(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        if (!self.name)
          enactor_room.update(room_area: nil)
          message = t('rooms.area_cleared')
        else
          enactor_room.update(room_area: self.name)
          message = t('rooms.area_set')
        end
        client.emit_success message
      end
    end
  end
end
