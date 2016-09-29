module AresMUSH
  module Rooms
    class RoomTypeCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs

      attr_accessor :name
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'rooms'
        super
      end
            
      def crack!
        self.name = trim_input(cmd.args)
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
        room.room_type = self.name.upcase
        if (room.room_type == "OOC")
          room.repose_on = false
        end
        room.save!
        client.emit_success t('rooms.room_type_set')
      end
    end
  end
end
