module AresMUSH
  module Scenes
    
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
    
    def self.scene_types
      AresMUSH::Global.read_config('scenes', 'scene_types' )      
    end
    
    def self.scene_pacing
      [ "Traditional", "Distracted", "Asynchronous" ]
    end
                   
    def self.is_valid_privacy?(privacy)
      ["Public", "Open", "Private"].include?(privacy)
    end
        
    def self.participated_in_scene?(char, scene)
      char.scenes_participated_in.include?("#{scene.id}")
    end
    
    def self.participants_and_room_chars(scene)
      participants = scene.participants.to_a
      if (scene.room)
        Rooms.online_chars_in_room(scene.room).each do |c|
          if (!participants.include?(c))
            participants << c
          end
        end
      end
      participants
    end
    
    def self.is_watching?(scene, char)
      return false if !char
      scene.watchers.include?(char)
    end
    
    def self.is_participant?(scene, char)
      return false if !char
      Scenes.participants_and_room_chars(scene).include?(char)
    end
    
    def self.add_participant(scene, char, enactor)
      if (!scene.participants.include?(char))
        scene.participants.add char
        
        if (!scene.completed && char != enactor)
          message = t('scenes.scene_notify_added_to_scene', :num => scene.id)
          Login.notify(char, :scene, message, scene.id, "", false)
          Login.emit_ooc_if_logged_in char, message
        end
      end
      
      if (!scene.watchers.include?(char))
        scene.watchers.add char
      end
    end
    
    def self.set_scene_location(scene, location, enactor = nil)
      matched_rooms = Room.find_by_name_and_area location
      area = nil
      vistas = {}
      
      if (matched_rooms.count == 1)
        room = matched_rooms.first
        if (room.is_temp_room?)
          description = location
        else
          description = "%xh#{room.name}%xn%R#{room.description}"
          area = room.area
          vistas = room.vistas
        end
      else
        description = location
      end
      
      scene.update(location: location)

      if (scene.temp_room && scene.room)
        #location = (location =~ /\//) ? location.after("/") : location
        scene.room.update(name: "Scene #{scene.id} - #{location}")
        scene.room.update(description: description)
        scene.room.update(area: area)
        scene.room.update(vistas: vistas)
      end
      
      data = Scenes.build_location_web_data(scene).to_json
      Scenes.new_scene_activity(scene, :location_updated, data)
      
      if (enactor)
        message = t('scenes.location_set', :name => enactor.name, :location => location)
        if (scene.room)
          scene.room.emit_ooc message
        end
      
        Scenes.add_to_scene(scene, message, Game.master.system_character, false, true)
      end
      
      
      
    end
    
    def self.info_missing_message(scene)
      t('scenes.scene_info_missing', :title => scene.title.blank? ? "??" : scene.title, 
                     :summary => scene.summary.blank? ? "??" : scene.summary,
                     :type => scene.scene_type.blank? ? "??" : scene.scene_type, 
                     :location => scene.location.blank? ? "??" : scene.location)
    end
    
    def self.find_all_scene_links(scene)
      links1 = SceneLink.find(log1_id: scene.id)
      links2 = SceneLink.find(log2_id: scene.id)
      links1.to_a.concat(links2.to_a)
    end 
    

    def self.recent_scenes
      (Game.master.recent_scenes || []).map { |id| Scene[id] }.select { |s| s }
    end
    
    def self.remove_recent_scene(scene)
      recent = Game.master.recent_scenes
      recent.delete scene.id
       Game.master.update(recent_scenes: recent)
    end
    
    def self.add_recent_scene(scene)
      recent = Game.master.recent_scenes
      recent.unshift("#{scene.id}")
      recent = recent.uniq
      if (recent.count > 30)
        recent.pop
      end
      Game.master.update(recent_scenes: recent)
    end
    
    def self.mark_read(scene, char)      
      tracker = char.get_or_create_read_tracker
      tracker.mark_scene_read(scene)
      Login.mark_notices_read(char, :scene, scene.id)
    end
    
    def self.mark_unread(scene, except_for_char = nil)
      chars = Character.all.select { |c| !Scenes.is_unread?(scene, c) }
      chars.each do |char|
        next if except_for_char && char == except_for_char
        tracker = char.get_or_create_read_tracker
        tracker.mark_scene_unread(scene)
      end
    end
    
    def self.is_unread?(scene, char)
      tracker = char.get_or_create_read_tracker
      tracker.is_scene_unread?(scene)
    end
    
    
  end
end