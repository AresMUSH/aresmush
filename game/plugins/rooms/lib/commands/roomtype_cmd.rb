module AresMUSH
  module Rooms
    class RoomTypeCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs

      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'rooms'
        super
      end
            
      def crack!
        self.name = trim_input(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end
      
      def check_room_type
        return nil if self.name.nil?
        return t('rooms.invalid_room_type', :types => Rooms.room_types.join(", ")) if !Rooms.room_types.include?(self.name.upcase)
        return nil
      end
      
      def handle
        client.room.room_type = self.name.upcase
        client.room.save!
        client.emit_success t('rooms.room_type_set')
      end
    end
  end
end
