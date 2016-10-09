module AresMUSH
  module Rooms
    class WorkCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs

      def check_work_set
        return t('rooms.work_not_set') if !enactor.room_work
        return nil
      end
      
      def check_can_go_work
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(enactor)
        return nil
      end
      
      def handle
        enactor.room.emit_ooc t('rooms.char_has_gone_work', :name => enactor.name)
        Rooms.move_to(client, enactor, enactor.room_work)
      end
    end
  end
end
