module AresMUSH
  module Pose
    class ReposeClearCmd
      include CommandHandler
      
      def check_repose_enabled
        return t('pose.repose_disabled') if !Pose.repose_enabled
      end
      
      def handle
        if (!enactor.room.repose_on?)
          client.emit_failure t('pose.repose_disabled')
          return
        end

        enactor.room.repose_info.reset
        client.emit_success t('pose.repose_cleared')
      end
    end
  end
end
