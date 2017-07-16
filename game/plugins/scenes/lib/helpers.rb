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
    
    def self.convert_to_log(scene)
      log = ""
      scene.scene_poses.each do |pose|
      formatted_pose = pose.pose || ""
      formatted_pose = formatted_pose.gsub(/</, '&lt;').gsub(/>/, '&gt;').gsub(/%r/i, "\n").gsub(/%t/i, "  ")
        if (pose.is_system_pose?)
          log << "[[div class=\"scene-system-pose\"]]#{formatted_pose}[[/div]]"
        elsif (pose.is_setpose?)
          log << "[[div class=\"scene-set-pose\"]]#{formatted_pose}[[/div]]"
        else
          log << formatted_pose
        end
        log << "\n\n"
      end
      log
    end
    
  end
end
