module AresMUSH
  module Scenes
    
    def self.new_scene_activity(scene, activity_type, data)
      last_posed = scene.last_posed ? scene.last_posed.name : nil
      
      # **NOTE** Don't add any more pipes after 'data' because poses can contain pipes.
      web_msg = "#{scene.id}|#{last_posed}|#{activity_type}|#{data}"
      Global.client_monitor.notify_web_clients(:new_scene_activity, web_msg, true) do |char|
        Scenes.can_read_scene?(char, scene) && Scenes.is_watching?(scene, char)
      end
      if (activity_type =~ /pose/)
        message = t('scenes.new_scene_activity', :id => scene.id)
        watching_participants = scene.watchers.to_a & scene.participants.to_a
        watching_participants.each do |w|
          if (last_posed != w.name)
            is_in_room = scene.room && scene.room == w.room
            Login.notify(w, :scene, message, scene.id, "", !is_in_room)
          end
        end
      end
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
    
    def self.remove_from_pose_order(enactor, target_name, room)
      room.remove_from_pose_order(target_name)   
      message = t('scenes.pose_order_dropped', :name => enactor.name, :dropped => target_name)
      room.emit_ooc message
      if (room.scene)
        Scenes.add_to_scene(room.scene, message, Game.master.system_character, false, true)
      end
      Scenes.notify_next_person(room)
    end

    def self.change_pose_order_type(room, enactor, type)
      room.update(pose_order_type: type)
      message = t('scenes.pose_order_type_changed', :name => enactor.name, :type => type)
      room.emit_ooc message
      if (room.scene)
        Scenes.add_to_scene(room.scene, message, Game.master.system_character, false, true)
      end
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
    
    # Returns whether the message should be emitted to the actual room.
    def self.send_to_ooc_chat_if_needed(enactor, client, message, is_emit)
      ooc_channel = Channels.ooc_lounge_channel
      return true if ooc_channel.blank?
      return true if enactor.room != Game.master.ooc_room
      
      if (is_emit)
        message = "#{message} (#{enactor.ooc_name})"
      end
      
      enabled = Channels.pose_to_channel_if_enabled(ooc_channel, enactor, message)
      if (!enabled)
        client.emit_failure t('scenes.no_talking_ooc_lounge', :channel => ooc_channel)
      end
      return false
    end
        
    
    def self.edit_pose(scene, scene_pose, new_text, enactor, notify)
      scene_pose.move_to_history
      scene_pose.update(pose: new_text)
      
      if (notify)
        
        if (scene_pose.is_ooc)
          message = t('scenes.edited_scene_ooc', :name => enactor.name, :pose => new_text)
        else
          message = t('scenes.edited_scene_pose', :name => enactor.name, :pose => new_text)
        end
      
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
    
    def self.format_quote_color(pose, char, is_ooc)
      quote_color = char.pose_quote_color
      if (is_ooc || quote_color.blank?)
        colored_pose = pose
      else
        
        quote_markers = "\u201C\u201D\u201E\u201F\u2033\u2036\""
        
        # (Group 1: Optional preceding junk before a quote) 
        # (Group 2: Quote -- Multiple letters not quote -- Quote )
        # /([^"]+)?("[^"]+")?/
        quote_matches = pose.scan(/([^#{quote_markers}]+)?([#{quote_markers}][^#{quote_markers}]+[#{quote_markers}]?)?/)
        
        colored_pose = ""
        quote_matches.each do |m| 
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
    
    def self.format_last_posed(time)
      TimeFormatter.format(Time.now - Time.parse(time))
    end
    
  end
end