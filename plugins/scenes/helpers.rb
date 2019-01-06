module AresMUSH
  module Scenes
    
    def self.new_scene_activity(scene, data = nil)
      last_posed = scene.last_posed ? scene.last_posed.name : nil
      web_msg = "#{scene.id}|#{last_posed}|#{data}"
      Global.client_monitor.notify_web_clients(:new_scene_activity, web_msg) do |char|
        Scenes.can_read_scene?(char, scene)
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
      Scenes.create_scene_temproom(scene)
      scene.update(completed: false)
      Scenes.set_scene_location(scene, scene.location)
      Scenes.new_scene_activity(scene)
    end
    
    def self.unshare_scene(enactor, scene)
      scene.update(shared: false)
      if (scene.scene_log)
        Scenes.add_to_scene(scene, scene.scene_log.log, enactor)
        scene.scene_log.delete
      end
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
      Global.logger.debug "Stopping scene #{scene.id}."
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
        end
        scene.update(room: nil)
      end

      scene.update(completed: true)
      scene.update(date_completed: Time.now)
      Scenes.new_scene_activity(scene)
      scene.participants.each do |char|
        Scenes.handle_scene_participation_achievement(char)
      end
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
      return true if char == scene.owner
      return Scenes.is_participant?(scene, char) || scene.watchers.include?(char)
    end
    
    def self.is_participant?(scene, char)
      Scenes.participants_and_room_chars(scene).include?(char)
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
        #location = (location =~ /\//) ? location.after("/") : location
        scene.room.update(name: "Scene #{scene.id} - #{location}")
        scene.room.update(description: description)
      end
      
      return message
    end
    
    def self.info_missing_message(scene)
      t('scenes.scene_info_missing', :title => scene.title.blank? ? "??" : scene.title, 
                     :summary => scene.summary.blank? ? "??" : scene.summary,
                     :type => scene.scene_type.blank? ? "??" : scene.scene_type, 
                     :location => scene.location.blank? ? "??" : scene.location)
    end
                   
    def self.is_valid_privacy?(privacy)
      ["Public", "Open", "Private"].include?(privacy)
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
        next if pose.is_ooc
        
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
        else
          if (div_started)
            log << "\n[[/div]]\n\n"
            div_started = false
          end
          log << formatted_pose
        end
        
        if (Global.read_config("scenes", "include_pose_separator"))
          log << "\n[[div class=\"pose-divider\"]][[/div]]\n"
        end
        
        log << "\n\n"
      end
      if (div_started)
        log << "\n[[/div]]\n\n"
      end
      
      log
    end

    def self.emit_pose(enactor, pose, is_emit, is_ooc, place_name = nil, system_pose = false, room = nil)
      room = room || enactor.room
      formatted_pose = pose
      
      if (is_ooc)
        color = Global.read_config("scenes", "ooc_color")
        formatted_pose = "#{color}<OOC>%xn #{pose}"
      end
      if (system_pose)
        line = "%R%xh%xc%% #{'-'.repeat(75)}%xn%R"
        formatted_pose = "#{line}%R#{pose}%R#{line}"
        is_emit = true
        room.update(scene_set: pose)
      end
      
      room.characters.each do |char|
        client = Login.find_client(char)
        next if !client
        client.emit Scenes.custom_format(formatted_pose, char, enactor, is_emit, is_ooc, place_name)
      end

      Global.dispatcher.queue_event PoseEvent.new(enactor, pose, is_emit, is_ooc, system_pose, room)
      
      if (!is_ooc && room.room_type != "OOC")
          Scenes.update_pose_order(enactor, room)
      end
    end
    
    def self.update_pose_order(enactor, room)
      room.update_pose_order(enactor.name)
      Scenes.notify_next_person(room)
    end

    def self.notify_next_person(room)
        
      poses = room.sorted_pose_order
      poses.each do |name, time|
        char = Character.find_one_by_name(name)
        client = Login.find_client(char)
        if (!char || !client || char.room != room)
          room.remove_from_pose_order(name)
        end
      end
          
      poses = room.sorted_pose_order
      return if poses.count < 2
 
      if (room.pose_order_type == '3-per')
        poses.reverse.each_with_index do |(name, time), i|
          next if i < 3
          char = Character.find_one_by_name(name)
          if (char.pose_nudge && !char.pose_nudge_muted)
            Login.emit_ooc_if_logged_in char, t('scenes.pose_threeper_nudge')
          end
        end
      else
        next_up_name = poses.first[0]
        char = Character.find_one_by_name(next_up_name)

        if (char.pose_nudge && !char.pose_nudge_muted)
          Login.emit_ooc_if_logged_in char, t('scenes.pose_your_turn')      
        end
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
      
      autospace = Scenes.format_autospace(enactor, is_ooc ? char.page_autospace : char.pose_autospace)
      "#{autospace}#{nospoof}#{place_title}#{colored_pose}"
    end  
    
    def self.find_all_scene_links(scene)
      links1 = SceneLink.find(log1_id: scene.id)
      links2 = SceneLink.find(log2_id: scene.id)
      links1.to_a.concat(links2.to_a)
    end 
    
    def self.handle_word_count_achievements(char, pose)
      [ 1000, 2000, 5000, 10000, 25000, 50000, 100000, 250000, 500000 ].each do |count|
        pretty_count = count.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
        message = "Wrote #{pretty_count} words in scenes."
        if (char.pose_word_count >= count)
          Achievements.award_achievement(char, "word_count_#{count}", 'story', message)
        end
      end
    end
    
    def self.handle_scene_participation_achievement(char)
      scenes = char.scenes_starring
      count = scenes.count
        
      Scenes.scene_types.each do |type|
        if (scenes.any? { |s| s.scene_type == type })
          message = "Participated in a #{type} scene."
          Achievements.award_achievement(char, "scene_participant_#{type.downcase}", 'story', message)
        end
      end
        
      [ 1, 10, 20, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000 ].each do |level|
        if ( count >= level )
          message = "Participated in #{level} #{level == 1 ? 'scene' : 'scenes'}."
          Achievements.award_achievement(char, "scene_participant_#{level}", 'story', message)
        end
      end
    end
  end
end
