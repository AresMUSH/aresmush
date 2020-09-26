module AresMUSH
  module Scenes
    class DeleteSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!Scenes.can_delete_scene?(enactor, scene))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (!scene.completed)
         return { error: t('scenes.cant_delete_in_progress_scene') }
        end        
        
        if (scene.shared)
          return { error: t('scenes.cant_delete_shared_scene') }
        end
        
        Global.logger.debug "Scene #{scene.id} deleted by #{enactor.name}."
        
        scene.delete
        {
        }
      end
    end
  end
end