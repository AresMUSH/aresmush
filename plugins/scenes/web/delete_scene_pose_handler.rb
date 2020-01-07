module AresMUSH
  module Scenes
    class DeleteScenePoseRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        scene_pose = ScenePose[request.args[:pose_id]]
        enactor = request.enactor
        
        if (!scene || !scene_pose)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!Scenes.can_edit_scene?(enactor, scene))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (!scene_pose.can_edit?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        Global.logger.debug "Scene #{scene.id} pose #{scene_pose.id} deleted by #{enactor.name}."
        
        pose_text = scene_pose.pose
        pose_id = scene_pose.id
        scene_pose.update(is_deleted: true)
        
        if (scene_pose.is_ooc)
          message = t('scenes.deleted_scene_ooc', :name => enactor.name, :pose => pose_text)
        else
          message = t('scenes.deleted_scene_pose', :name => enactor.name, :pose => pose_text)
        end
        
        if (scene.room)
          scene.room.emit_ooc message
        end                
                
        data = { id: pose_id }.to_json
        Scenes.new_scene_activity(scene, :pose_deleted, data)

        Scenes.add_to_scene(scene, message, Game.master.system_character, false, true)
        
        {}
      end
    end
  end
end