module AresMUSH
  module Scenes
    
    def self.new_scene_activity(scene, activity_type, data)
      last_posed = scene.last_posed ? scene.last_posed.name : nil
      web_msg = "#{scene.id}|#{last_posed}|#{activity_type}|#{data}"
      Global.client_monitor.notify_web_clients(:new_scene_activity, web_msg) do |char|
        Scenes.can_read_scene?(char, scene) && Scenes.is_watching?(scene, char)
      end
      if (activity_type =~ /pose/)
        message = t('scenes.new_scene_activity')
        scene.watchers.each do |w|
          if (last_posed != w.name)
            Login.notify(w, :scene, message, "")
          end
        end
      end
    end
    
    def self.can_manage_scene?(actor, scene)
      return false if !actor
      actor.has_permission?("manage_scenes")
    end
    
    def self.scene_types
      AresMUSH::Global.read_config('scenes', 'scene_types' )      
    end

    def self.can_read_scene?(actor, scene)
      return !scene.is_private? if !actor
      return true if scene.owner == actor
      return true if !scene.is_private?
      return true if actor.room == scene.room
      return true if scene.invited.include?(actor)
      scene.participants.include?(actor)
    end
    
    def self.can_edit_scene?(actor, scene)
      return false if !actor
      return true if scene.owner == actor
      return true if Scenes.can_manage_scene?(actor, scene)
      scene.participants.include?(actor)
    end
    
    def self.can_delete_scene?(actor, scene)
      return false if !actor
      real_poses = scene.scene_poses.select { |p| !p.is_ooc }
      return true if (scene.owner == actor && (real_poses.count == 0) && !scene.scene_log)
      return true if Scenes.can_manage_scene?(actor, scene)
      return false
    end
    
    def self.restart_scene(scene)
      Scenes.create_scene_temproom(scene)
      scene.update(completed: false)
      scene.update(was_restarted: true)
      Scenes.new_scene_activity(scene, :status_changed, nil)
    end
    
    def self.unshare_scene(enactor, scene)
      scene.update(shared: false)
      if (scene.scene_log)
        pose = Scenes.add_to_scene(scene, scene.scene_log.log, enactor)
        if (pose)
          pose.update(restarted_scene_pose: true)
          scene.scene_log.delete
        else 
          Global.logger.warn "Problem adding restarted scene pose."
        end
      end
      Scenes.remove_recent_scene(scene)
      Scenes.new_scene_activity(scene, :status_changed, nil)
    end
    
    def self.share_scene(scene)
      if (!scene.all_info_set?)
        return false
      end
      
      if (scene.shared)
        Global.logger.warn "Attempt to share an already-shared scene."
        return
      end
      
      scene.update(shared: true)
      scene.update(date_shared: Time.now)
      Scenes.create_log(scene)
      Scenes.add_recent_scene(scene)
      
      Scenes.new_scene_activity(scene, :status_changed, nil)  
      Global.dispatcher.queue_event SceneSharedEvent.new(scene.id)
            
      return true
    end
      
    def self.stop_scene(scene, enactor)
      Global.logger.debug "Stopping scene #{scene.id}."
      return if scene.completed
      
      if (scene.room)
        scene.room.characters.each do |c|
          connected_client = Login.find_client(c)
        
          if (scene.temp_room)
            Scenes.send_home_from_scene(c)
            message = t('scenes.scene_ending', :name => enactor.name)
          else
            message = t('scenes.scene_ending_public', :name => enactor.name)
          end
          
          if (connected_client)
            connected_client.emit_ooc message
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
      
      Scenes.new_scene_activity(scene, :status_changed, nil)
      
      if (!scene.was_restarted)
        scene.participants.each do |char|
          Scenes.handle_scene_participation_achievement(char)
          if (FS3Skills.is_enabled?)
            FS3Skills.luck_for_scene(char, scene)
          end
        end
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
      scene.watchers.include?(char)
    end
    
    def self.is_participant?(scene, char)
      Scenes.participants_and_room_chars(scene).include?(char)
    end
    
    def self.add_participant(scene, char)
      if (!scene.participants.include?(char))
        scene.participants.add char
      end
      
      if (!scene.watchers.include?(char))
        scene.watchers.add char
      end
    end
    
    def self.set_scene_location(scene, location, enactor = nil)
      matched_rooms = Room.find_by_name_and_area location
      area = nil
      
      if (matched_rooms.count == 1)
        room = matched_rooms.first
        if (room.scene && room.scene.temp_room)
          description = location
        else
          description = "%xh#{room.name}%xn%R#{room.description}"
          area = room.area
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
      old_text = ""
      if (scene.scene_log)
        old_text = "#{scene.scene_log.log}\n"
        scene.scene_log.delete
      end
      log = Scenes.build_log_text(scene)
      scene_log = SceneLog.create(scene: scene, log: "#{old_text}#{log}")
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
        
        if (pose.place_name)
          formatted_pose = "*At #{pose.place_name}*:\n#{pose.pose}"
        else
          formatted_pose = "#{pose.pose}"
        end
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

    # Place name overrides whatever place the character is in.
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
      end
      
      room.characters.each do |char|
        client = Login.find_client(char)
        next if !client
        client.emit Scenes.custom_format(formatted_pose, room, char, enactor, is_emit, is_ooc, place_name)
      end

      Global.dispatcher.queue_event PoseEvent.new(enactor, pose, is_emit, is_ooc, system_pose, room, place_name)
      
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
      return if poses.count < 2
 
      if (room.pose_order_type == '3-per')
        poses.reverse.each_with_index do |(name, time), i|
          next if i < 3
          char = Character.find_one_by_name(name)
          if (!char)
            room.remove_from_pose_order(name)
          end
          client = Login.find_client(char)
          if (client && char.pose_nudge && !char.pose_nudge_muted)
            if (char.room == room)
              client.emit_ooc t('scenes.pose_your_turn')
            elsif (room.scene)
              client.emit_ooc t('scenes.pose_threeper_nudge_other_scene', :scene => room.scene.id)
            end
          end
        end
      else
        next_up_name = poses.first[0]
        char = Character.find_one_by_name(next_up_name)
        if (!char)
          room.remove_from_pose_order(next_up_name)
        end
        client = Login.find_client(char)
        if (client && char.pose_nudge && !char.pose_nudge_muted)
          if (char.room == room)
            client.emit_ooc t('scenes.pose_your_turn')
          elsif (room.scene)
            client.emit_ooc t('scenes.pose_your_turn_other_scene', :scene => room.scene.id)
          end
        end
      end
    end
    
    def self.format_quote_color(pose, char, is_ooc)
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
      colored_pose
    end
    
    def self.format_for_place(room, enactor, char, pose, is_ooc, place_name = nil)
      # Override char's current place.
      
      if (!place_name)
        if (!enactor.place(room) || is_ooc)
          return pose
        end
        place_name = enactor.place_name(room)
      end
      
      same_place = (char.place(room) ? char.place(room).name : nil) == place_name
      place_title = Places.place_title(place_name, same_place)
      place_prefix = Places.place_prefix(same_place)
      
      if (!place_title.blank?)
        pose = pose.gsub("%R", "%R#{place_prefix} ")
      end
      
      "#{place_title}#{pose}"
    end

    def self.custom_format(pose, room, char, enactor, is_emit = false, is_ooc = false, place_name = nil)
      nospoof = ""
      if (is_emit && char.pose_nospoof)
        nospoof = "%xc%% #{t('scenes.emit_nospoof_from', :name => enactor.name)}%xn%R"
      end
      
      formatted_pose = Scenes.format_for_place(room, enactor, char, pose, is_ooc, place_name)
      formatted_pose = Scenes.format_quote_color(formatted_pose, char, is_ooc)
            
      autospace = Scenes.format_autospace(enactor, is_ooc ? char.page_autospace : char.pose_autospace)
      "#{autospace}#{nospoof}#{formatted_pose}"
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
    
    # Returns whether the message should be emitted to the actual room.
    def self.send_to_ooc_chat_if_needed(enactor, client, message)
      ooc_channel = Channels.ooc_lounge_channel
      return true if ooc_channel.blank?
      return true if enactor.room != Game.master.ooc_room
      
      enabled = Channels.pose_to_channel_if_enabled(ooc_channel, enactor, message)
      if (!enabled)
        client.emit_failure t('scenes.no_talking_ooc_lounge', :channel => ooc_channel)
      end
      return false
    end
    
    def self.mark_read(scene, char)      
      scenes = char.read_scenes || []
      scenes << scene.id.to_s
      char.update(read_scenes: scenes)
    end
    
    def self.mark_unread(scene, except_for_char = nil)
      chars = Character.all.select { |c| !Scenes.is_unread?(scene, c) }
      chars.each do |char|
        next if except_for_char && char == except_for_char
        scenes = char.read_scenes || []
        scenes.delete scene.id.to_s
        char.update(read_scenes: scenes)
      end
    end
    
    def self.edit_pose(scene, scene_pose, new_text, enactor, notify)
      scene_pose.move_to_history
      scene_pose.update(pose: new_text)
      
      if (notify)
        message = t('scenes.edited_scene_pose', :name => enactor.name, :pose => new_text)
      
        if (scene.room)
          scene.room.emit_ooc message
        end
        
        Scenes.add_to_scene(scene, message, Game.master.system_character, false, true)
        
      end

      data = { id: scene_pose.id, 
               pose: Website.format_markdown_for_html(new_text),
               raw_pose: new_text }.to_json
      Scenes.new_scene_activity(scene, :pose_updated, data)
      
      Global.logger.debug("Scene #{scene.id} pose #{scene_pose.id} edited by #{enactor ? enactor.name : 'Anonymous'}.")
      
    end
    
    def self.is_unread?(scene, char)
      !(char.read_scenes || []).include?(scene.id.to_s)
    end
    
    def self.format_last_posed(time)
      TimeFormatter.format(Time.now - Time.parse(time))
    end
    
    def self.leave_scene(scene, char)
      scene.watchers.delete char
      scene.room.remove_from_pose_order(char.name)   
    end
    
    def self.send_home_from_scene(char)
      case char.scene_home
      when 'home'
        Rooms.send_to_home(char)
      when 'work'
        Rooms.send_to_work(char)
      else
        Rooms.send_to_ooc_room(char)
      end
    end

    def self.build_scene_pose_web_data(pose, viewer, live_update = false)
      {
        char: { name: pose.character ? pose.character.name : t('global.deleted_character'), 
                icon: Website.icon_for_char(pose.character),
                id: pose.character ? pose.character.id : 0 }, 
        order: pose.order, 
        id: pose.id,
        timestamp: OOCTime.local_long_timestr(viewer, pose.created_at),
        is_setpose: pose.is_setpose,
        is_system_pose: pose.is_system_pose?,
        restarted_scene_pose: pose.restarted_scene_pose,
        place_name: pose.place_name,
        is_ooc: pose.is_ooc,
        raw_pose: pose.pose,
        can_edit: pose.can_edit?(viewer),
        can_delete: pose.restarted_scene_pose ? false : pose.can_edit?(viewer),
        pose: Website.format_markdown_for_html(pose.pose),
        live_update: live_update
      }
    end
    
    def self.build_live_scene_web_data(scene, viewer)
      participants = Scenes.participants_and_room_chars(scene)
          .sort_by {|p| p.name }
          .map { |p| { 
            name: p.name, 
            id: p.id, 
            icon: Website.icon_for_char(p), 
            status: Website.activity_status(p),
            is_ooc: p.is_admin? || p.is_playerbit?,
            online: Login.is_online?(p)  }}
      
      if (scene.room)
        places = scene.room.places.to_a.sort_by { |p| p.name }.map { |p| {
          name: p.name,
          chars: p.characters.map { |c| {
            name: c.name,
            icon: Website.icon_for_char(c)
          }}
        }}
      else
        places = nil
      end
         
      combat = FS3Combat.is_enabled? ? FS3Combat.combat_for_scene(scene) : nil
      
      {
        id: scene.id,
        title: scene.title,
        location: Scenes.build_location_web_data(scene),
        completed: scene.completed,
        summary: Website.format_markdown_for_html(scene.summary),
        content_warning: scene.content_warning,
        tags: scene.tags,
        icdate: scene.icdate,
        is_private: scene.private_scene,
        participants: participants,
        scene_type: scene.scene_type ? scene.scene_type.titlecase : 'unknown',
        can_edit: viewer && Scenes.can_edit_scene?(viewer, scene),
        can_delete: Scenes.can_delete_scene?(viewer, scene),
        is_watching: viewer && scene.watchers.include?(viewer),
        is_unread: viewer && scene.is_unread?(viewer),
        pose_order: Scenes.build_pose_order_web_data(scene),
        combat: combat ? combat.id : nil,
        places: places,
        poses: scene.poses_in_order.map { |p| Scenes.build_scene_pose_web_data(p, viewer) },
        fs3_enabled: FS3Skills.is_enabled?,
        fs3combat_enabled: FS3Combat.is_enabled?
      }
    end
    
    def self.build_location_web_data(scene)
      {
        name: scene.location,
        description: scene.room ? Website.format_markdown_for_html(scene.room.expanded_desc) : nil,
        scene_set: scene.room ? Website.format_markdown_for_html(scene.room.scene_set) : nil
      }
    end
    
    def self.build_pose_order_web_data(scene)
      return {} if !scene.room
      scene.room.sorted_pose_order.map { |name, time| 
        {
         name: name,
         time: Time.parse(time).rfc2822
         }}
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
  end
end
