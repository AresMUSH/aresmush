module AresMUSH
  module Rooms
    class RoomIconCmd
      include CommandHandler

      attr_accessor :type
            
      def parse_args
        self.type = trim_arg(cmd.args)
      end

      def check_can_build
        types = (Global.read_config('rooms', 'icon_types') || {}).keys

        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return t('rooms.invalid_icon_type', :types => types.join(", ")) if (self.type && !types.include?(self.type))
        return nil
      end
      
      def handle
        enactor_room.update(room_icon: self.type)
        client.emit_ooc t('rooms.icon_set')
      end
    end
  end
end
