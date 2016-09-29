module AresMUSH
  module Rooms
    class AreaCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches

      attr_accessor :name
      
      def crack!
        self.name = cmd.args.nil? ? nil : trim_input(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        if (self.name.nil?)
          enactor_room.area = nil
          message = t('rooms.area_cleared')
        else
          enactor_room.area = self.name
          message = t('rooms.area_set')
        end
        enactor_room.save!
        client.emit_success message
      end
    end
  end
end
