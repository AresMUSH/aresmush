module AresMUSH
  module Rooms
    class WorkSetCmd
      include CommandHandler
      
      def check_can_go_work
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(enactor)
        return nil
      end
      
      def handle
        enactor.update(room_work: enactor.room)
        client.emit_ooc t('rooms.work_set')
      end
    end
  end
end
