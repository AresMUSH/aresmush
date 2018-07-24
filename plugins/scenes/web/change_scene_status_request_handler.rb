module AresMUSH
  module Scenes
    class ChangeSceneStatusRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        status = request.args[:status]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!Scenes.can_access_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end
        
        case status
        when "restart"
          if (!scene.completed)
            return { error: t('scenes.cant_restart_in_progress_scene') }
          end
          
          if (scene.shared)
            return { error: t('scenes.cant_restart_shared_scene') }
          end
          
          Scenes.restart_scene(scene)
          
        when "stop"
          if (scene.completed)
            return { error: t('scenes.scene_already_completed')}
          end
          
          Scenes.stop_scene(scene)
          
        when "share"
          if (!scene.all_info_set?)
            return { error: t('scenes.missing_required_fields')}
          end
          
          Scenes.share_scene(scene)
          
        else
          return { error: t('webportal.unexpected_error') }
        end
        
        {}
      end
    end
  end
end