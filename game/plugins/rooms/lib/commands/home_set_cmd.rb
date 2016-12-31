module AresMUSH
  module Rooms
    class HomeSetCmd
      include CommandHandler
      
      def check_can_go_home
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(enactor)
        return nil
      end
      
      def handle
        client.emit_ooc t('rooms.home_set')
        enactor.update(room_home: enactor.room)
      end
    end
  end
end
