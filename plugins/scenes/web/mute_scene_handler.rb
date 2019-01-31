module AresMUSH
  module Scenes
    class MuteSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        muted = (request.args[:muted] || "").to_bool
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!scene.participants.include?(enactor))
          return { error: t('scenes.not_a_part_of_scene') }
        end
        
        if (muted)
          Global.logger.debug "Scene #{scene.id} muted by #{enactor.name}."
        
          if (!scene.muters.include?(enactor))
            scene.muters.add enactor
          end
        else
          Global.logger.debug "Scene #{scene.id} unmuted by #{enactor.name}."
        
          if (scene.muters.include?(enactor))
            scene.muters.delete enactor
          end
        end
        
        {}
      end
    end
  end
end