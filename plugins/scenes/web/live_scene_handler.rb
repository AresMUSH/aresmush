module AresMUSH
  module Scenes
    class LiveSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request, true)
        return error if error
        
        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.scene_is_private') }
        end
        
        if (scene.shared)
          return { shared: true }
        end
        
        if (!scene.logging_enabled)
          return { error: t('scenes.cant_join_unlogged_scene')}
        end
        
        if (enactor)
          scene.mark_read(enactor)
            
          if (!Scenes.is_watching?(scene, enactor))
            scene.watchers.add enactor
          end
          
          Login.mark_notices_read(enactor, :scene, scene.id)
          Login.mark_notices_read(enactor, :scene_deletion, scene.id)

        end
        
        Scenes.build_live_scene_web_data(scene, enactor)
      end
    end
  end
end