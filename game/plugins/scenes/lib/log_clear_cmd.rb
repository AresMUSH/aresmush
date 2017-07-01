module AresMUSH
  module Scenes
    class ReposeClearCmd
      include CommandHandler
            
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
