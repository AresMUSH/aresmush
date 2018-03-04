module AresMUSH
  module Scenes
    
    def self.new_scene_activity(scene)
      Global.client_monitor.notify_web_clients(:new_scene_activity, "#{scene.id}") do |char|
        char && (!scene.private_scene || Scenes.participants_and_room_chars(scene).include?(char))
      end
    end
    
    def self.can_manage_scene?(actor, scene)
      return false if !actor
      (scene.owner == actor) || actor.has_permission?("manage_scenes")
    end
    
    
    def self.scene_types
      AresMUSH::Global.read_config('scenes', 'scene_types' )      
    end

    def self.can_read_scene?(actor, scene)
      return !scene.is_private? if !actor
      return true if scene.owner == actor
      return true if !scene.is_private?
      return true if actor.room == scene.room
      scene.participants.include?(actor)
    end
        
    def self.can_access_scene?(actor, scene)
      return !scene.is_private? if !actor
      return true if Scenes.can_manage_scene?(actor, scene)
      return true if !scene.is_private?
      scene.participants.include?(actor)
    end
    
    def self.can_edit_scene?(actor, scene)
      return false if !actor
      return true if Scenes.can_manage_scene?(actor, scene)
      scene.participants.include?(actor)
    end
    
    def self.restart_scene(scene)
      scene.update(completed: false)
      Scenes.new_scene_activity(scene)
    end
    
    def self.share_scene(scene)
      if (!scene.all_info_set?)
        return false
      end
      
      scene.update(shared: true)
      scene.update(date_shared: Time.now)
      Scenes.create_log(scene)
      Scenes.new_scene_activity(scene)
      
      return true
    end
      
    def self.stop_scene(scene)
      return if scene.completed
      
      if (scene.room)
        scene.room.characters.each do |c|
          connected_client = Login.find_client(c)
          if (connected_client)
            connected_client.emit_ooc t('scenes.scene_ending')
          end
        
          if (scene.temp_room)
            Rooms.send_to_ooc_room(connected_client, c)
          end
        end
        
        if (scene.temp_room)
          scene.room.delete
        else
          scene.room.update(scene: nil)
          scene.update(room: nil)
        end
        
      end

      scene.update(completed: true)
      scene.update(date_completed: Time.now)
      Scenes.new_scene_activity(scene)
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
    
    def self.set_scene_location(scene, location)
      matched_rooms = Room.find_by_name_and_area location
      
      if (matched_rooms.count == 1)
        room = matched_rooms.first
        if (room.scene && room.scene.temp_room)
          description = location
        else
          description = "%xh#{room.name}%xn%R#{room.description}"
        end
      else
        description = location
      end
      
      scene.update(location: location)

      message = t('scenes.location_set', :description => description)
      if (scene.temp_room && scene.room)
        location = (location =~ /\//) ? location.after("/") : location
        scene.room.update(name: "Scene #{scene.id} - #{location}")
        Describe.update_current_desc(scene.room, description)
      end
      
      return message
    end
    
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
    
    def self.create_scene_temproom(scene)
      room = Room.create(scene: scene, room_type: "RPR", name: "Scene #{scene.id}")
      ex = Exit.create(name: "O", source: room, dest: Game.master.ooc_room)
      scene.update(room: room)
      scene.update(temp_room: true)
      Scenes.set_scene_location(scene, scene.location)
      room
    end
    
    def self.build_log_text(scene)
      log = ""
      div_started = false
      scene.poses_in_order.to_a.each do |pose|
        formatted_pose = pose.pose || ""
        formatted_pose = formatted_pose.gsub(/</, '&lt;').gsub(/>/, '&gt;').gsub(/%r/i, "\n").gsub(/%t/i, "  ")
        
        formatted_pose = formatted_pose.split("\n").map { |line| line.strip }.join("\n")
        
        if (pose.is_system_pose?)
          if (!div_started)
            log << "[[div class=\"scene-system-pose\"]]\n"
            div_started = true
          end
          log << formatted_pose
        elsif (pose.is_setpose?)
          log << "[[div class=\"scene-set-pose\"]]\n#{formatted_pose}\n[[/div]]\n\n"
        elsif (pose.is_ooc)
          # Strip OOC from log
        else
          if (div_started)
            log << "\n[[/div]]\n\n"
            div_started = false
          end
          log << formatted_pose
        end
        log << "\n\n"
      end
      if (div_started)
        log << "\n[[/div]]\n\n"
      end
      
      log
    end

    def self.emit_pose(enactor, pose, is_emit, is_ooc, place_name = nil, system_pose = false)
      room = enactor.room
      formatted_pose = pose
      
      if (is_ooc)
        color = Global.read_config("scenes", "ooc_color")
        formatted_pose = "#{color}<OOC>%xn #{pose}"
      end
      if (system_pose)
        line = "%R%xh%xc%% #{'-'.repeat(75)}%xn%R"
        formatted_pose = "#{line}%R#{pose}%R#{line}"
      end
      
      enactor.room.characters.each do |char|
        client = Login.find_client(char)
        next if !client
        client.emit Scenes.custom_format(formatted_pose, char, enactor, is_emit, is_ooc, place_name)
      end

      Global.dispatcher.queue_event PoseEvent.new(enactor, pose, is_emit, is_ooc, system_pose)
      
      if (!is_ooc)
        if (room.room_type != "OOC")
          enactor.room.update_pose_order(enactor.name.titlecase)
          Scenes.notify_next_person(enactor.room)
        end
      end
    end

    def self.notify_next_person(room)
      return if room.pose_order.count < 3
        
      poses = room.sorted_pose_order
            
      next_up_name = poses.first[0]
      next_up_char = Character.find_one_by_name(next_up_name)
      next_up_client = Login.find_client(next_up_char)
      
      if ((next_up_char.room != room) || !next_up_client)
        room.remove_from_pose_order(next_up_name)
        Scenes.notify_next_person(room)
      elsif (next_up_char.pose_nudge && !next_up_char.pose_nudge_muted)
        next_up_client.emit_ooc t('scenes.pose_your_turn')      
      end
    end
    
    def self.custom_format(pose, char, enactor, is_emit = false, is_ooc = false, place_name = nil)
      nospoof = ""
      if (is_emit && char.pose_nospoof)
        nospoof = "%xc%% #{t('scenes.emit_nospoof_from', :name => enactor.name)}%xn%R"
      end
      
      if (place_name)
        same_place = (char.place ? char.place.name : nil) == place_name
        place_title = Places.place_title(place_name, same_place)
      else
        place_title = is_ooc ? "" : enactor.place_title(char)
      end
      
      quote_color = char.pose_quote_color
      if (is_ooc || quote_color.blank?)
        colored_pose = pose
      else
        matches = pose.scan(/([^"]+)?("[^"]+")?/)
        colored_pose = ""
        matches.each do |m| 
          if (m[0])
            colored_pose << "#{m[0]}"
          end
          if (m[1])
            colored_pose << "#{quote_color}#{m[1]}%xn"
          end
        end
      end
      
      "#{char.pose_autospace}#{nospoof}#{place_title}#{colored_pose}"
    end  
    
    def self.find_all_scene_links(scene)
      links1 = SceneLink.find(log1_id: scene.id)
      links2 = SceneLink.find(log2_id: scene.id)
      links1.to_a.concat(links2.to_a)
    end 
  end
end
