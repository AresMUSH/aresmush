module AresMUSH
  module Scenes
    class ChangeSceneLocationHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        location = request.args[:location]
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (!Scenes.can_access_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end
        
        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end
        
        Global.logger.debug "Scene #{scene.id} location changed to #{location} by #{enactor.name}."
        
        message = Scenes.set_scene_location(scene, location)
        
        if (scene.room)
          scene.room.emit message
        end
        
        Scenes.add_to_scene(scene, message, Game.master.system_character)
        
        {
        }
      end
    end
  end
end