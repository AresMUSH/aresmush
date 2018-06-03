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
        
        notify_of_watch = Global.read_config("scenes", "notify_of_web_watching")
        
        if (watch)
          if (notify_of_watch && scene.room && !scene.watchers.include?(enactor))
            scene.room.emit_ooc t('scenes.started_watching', :name => enactor.name)
          end
          scene.watchers.add enactor
        else
          scene.watchers.delete enactor
          if (notify_of_watch && scene.room)
            scene.room.emit_ooc t('scenes.stopped_watching', :name => enactor.name)
          end
        end
        
        {}
      end
    end
  end
end