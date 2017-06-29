module AresMUSH
  module Scenes
    class ReposeClearCmd
      include CommandHandler
      
      def check_repose_enabled
        return t('pose.repose_disabled') if !Pose.repose_enabled
      end
      
      def handle
        if (!enactor.room.repose_on?)
          client.emit_failure t('pose.repose_off')
          return
        end

        enactor.room.repose_info.reset
        if (enactor.room.scene)
          Scenes::Api.reset_poses(enactor.room.scene.id)
        end
        client.emit_success t('pose.repose_cleared')
      end
    end
  end
end
