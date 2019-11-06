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

        scene.room.remove_from_pose_order(name)   
        message = t('scenes.pose_order_dropped', :name => enactor.name, :dropped => name)
        Scenes.emit_pose(enactor, message, false, false, nil, true, scene.room)
        Scenes.notify_next_person(scene.room)
        
        {
        }
      end
    end
  end
end