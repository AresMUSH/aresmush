module AresMUSH
  module Scenes
    class SwitchPoseOrderRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        
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
        
        Global.logger.debug "Scene #{scene.id} switch pose order by #{enactor.name}."

        new_type = scene.room.pose_order_type == 'normal' ? '3-per' : 'normal'
        
        scene.room.update(pose_order_type: new_type)
        message = t('scenes.pose_order_type_changed', :name => enactor.name, :type => new_type)
        Scenes.emit_pose(enactor, message, false, false, nil, true)
        
        {
        }
      end
    end
  end
end