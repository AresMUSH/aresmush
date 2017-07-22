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
    
    def self.format_room_name_for_match(room, search_name)
      if (search_name =~ /\//)
        return "#{room.area}/#{room.name}".upcase
      else
        return room.name.upcase
      end
    end
    
    def self.create_or_update_log(scene)
      if (scene.scene_log)
        new_log = Scenes.build_log_text(scene)
        scene.scene_log.update(log: new_log)
      else
        log = Scenes.build_log_text(scene)
        scene_log = SceneLog.create(scene: scene, log: log)
        scene.update(scene_log: scene_log)
      end
    end
    
    def self.build_log_text(scene)
      log = ""
      div_started = false
      scene.scene_poses.each do |pose|
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
