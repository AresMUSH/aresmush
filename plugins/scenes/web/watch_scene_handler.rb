module AresMUSH
  module Scenes
    class WatchSceneRequestHandler
      def handle(request)
        scene = Scene[request.args['id']]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.scene_is_private') }
        end
        
        if (!scene.watchers.include?(enactor))
          scene.watchers.add enactor
        end
                    
        {}
      end
    end
  end
end