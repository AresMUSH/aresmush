module AresMUSH
  module Rooms
    class WorkSetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def check_can_go_work
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(enactor)
        return nil
      end
      
      def handle
        client.emit_ooc t('rooms.work_set')
        enactor.work = enactor.room
        enactor.save!
      end
    end
  end
end
