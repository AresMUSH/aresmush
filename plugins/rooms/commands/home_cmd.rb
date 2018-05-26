module AresMUSH
  module Rooms
    class HomeCmd
      include CommandHandler

      def check_home_set
        return t('rooms.home_not_set') if !enactor.room_home
        return nil
      end
      
      def check_can_go_home
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(enactor)
        return nil
      end
      
      def handle
        enactor_room.emit_ooc t('rooms.char_has_gone_home', :name => enactor.name)
        Rooms.move_to(client, enactor, enactor.room_home)
      end
    end
  end
end
