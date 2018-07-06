module AresMUSH
  module Scenes
    class WatchSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        watch = request.args[:watch].to_bool
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end

        if (!enactor)
          return {}
        end
        
        error = WebHelpers.check_login(request, true)
        return error if error

        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.scene_is_private') }
        end
        
        
        if (watch)
          scene.watchers.add enactor
        else
          scene.watchers.delete enactor
        end
        
        {}
      end
    end
  end
end