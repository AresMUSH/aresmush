module AresMUSH
  module Scenes
   
    def self.is_valid_privacy?(privacy)
      ["Public", "Private"].include?(privacy)
    end
    
    def self.with_a_scene(scene_id, client, &block)
      if (!scene_id)
        client.emit_failure t('scenes.scene_not_specified')
        return
      end
      
      scene = Scene[scene_id]
      if (!scene)
        client.emit_failure t('scenes.scene_not_found')
        return
      end
      
      yield scene
    end    
    
    def self.create_log(scene)
      if (scene.scene_log)
        scene.scene_log.delete
      end
      log = Scenes.build_log_text(scene)
      scene_log = SceneLog.create(scene: scene, log: log)
      scene.update(scene_log: scene_log)
      scene.scene_poses.each { |p| p.delete }  
    end
    
    def self.build_log_text(scene)
      log = ""
      div_started = false
      scene.poses_in_order.to_a.each do |pose|
        formatted_pose = pose.pose || ""
        formatted_pose = formatted_pose.gsub(/</, '&lt;').gsub(/>/, '&gt;').gsub(/%r/i, "\n").gsub(/%t/i, "  ")
        if (pose.is_system_pose?)
          if (!div_started)
            log << "[[div class=\"scene-system-pose\"]]\n"
            div_started = true
          end
          log << formatted_pose
        elsif (pose.is_setpose?)
          log << "[[div class=\"scene-set-pose\"]]\n#{formatted_pose}\n[[/div]]"
        else
          if (div_started)
            log << "\n[[/div]]"
            div_started = false
          end
          log << formatted_pose
        end
        log << "\n\n"
      end
      if (div_started)
        log << "\n[[/div]]"
      end
      
      log
    end
    
  end
end
