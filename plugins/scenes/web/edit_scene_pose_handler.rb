module AresMUSH
  module Scenes
    class EditScenePoseRequestHandler
      def handle(request)
        scene = Scene[request.args['scene_id']]
        scene_pose = ScenePose[request.args['pose_id']]
        pose_text = request.args['pose']
        notify = (request.args['notify'] || "").to_bool
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
                
        Scenes.edit_pose(scene, scene_pose, pose_text, enactor, notify)
        
        { pose: Website.format_markdown_for_html(pose_text) }
      end
    end
  end
end