module AresMUSH
  module Pose
    class ReposeClearCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def check_repose_enabled
        return t('pose.repose_disabled') if !Pose.repose_enabled
      end
      
      def handle
        repose = enactor.room.repose_info
        if (repose)
          repose.delete
        end
        repose = ReposeInfo.create(room: enactor.room)
        enactor.room.update(repose_info: repose)
        client.emit_success t('pose.repose_cleared')
      end
    end
  end
end
