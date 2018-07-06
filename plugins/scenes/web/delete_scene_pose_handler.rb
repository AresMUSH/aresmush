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
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!Scenes.can_access_scene?(enactor, scene))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (!scene_pose.can_edit?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        pose_text = scene_pose.pose
        scene_pose.delete
        
        message = t('scenes.deleted_scene_pose', :name => enactor.name, :pose => pose_text)
        
        if (scene.room)
          scene.room.emit_ooc message
        end
        
        Scenes.add_to_scene(scene, WebHelpers.format_markdown_for_html(message), Game.master.system_character, is_setpose = false, is_ooc = true)
        {}
      end
    end
  end
end