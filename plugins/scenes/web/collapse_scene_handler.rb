module AresMUSH
  module Scenes
    class CollapseScenePosesRequestHandler
      def handle(request)
        scene = Scene[request.args['id']]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (scene.shared)
          return { error: t('scenes.scene_already_shared') }
        end
        
        if (!scene.completed)
          return { error: t('scenes.cant_collapse_until_completed') }
        end
        
        if (!Scenes.can_edit_scene?(enactor, scene))
          return { error: t('dispatcher.not_allowed') }
        end
        
        Global.logger.debug "Scene #{scene.id} collapsed by #{enactor.name}."
               
        text = Scenes.build_log_text(scene)
        scene.scene_poses.each { |p| p.delete }  
        pose = Scenes.add_to_scene(scene, text, enactor)
        pose.update(restarted_scene_pose: true)
        
        {}
      end
    end
  end
end