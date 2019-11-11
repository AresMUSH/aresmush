module AresMUSH
  module Scenes
    class DropPoseOrderRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        name = request.args[:name]
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (!Scenes.can_edit_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end
        
        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end
        
        Global.logger.debug "Scene #{scene.id} pose order dropping #{name} by #{enactor.name}."
        Scenes.remove_from_pose_order(enactor, name, scene.room)
        
        {
        }
      end
    end
  end
end