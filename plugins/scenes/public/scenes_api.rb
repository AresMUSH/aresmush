module AresMUSH
  module Scenes
    
    def self.emit(enactor, pose, place_name = nil)
      Scenes.emit_pose(enactor, pose, true, false, place_name)
    end
    
    def self.emit_setpose(enactor, pose)
      Scenes.emit_pose(enactor, pose, true, false, nil, true)
    end
    
    def self.colorize_quotes(room, enactor, pose, recipient)
      Scenes.custom_format(pose, room, recipient, enactor)
    end
    
    def self.format_autospace(enactor, autospace_str)
      return autospace_str if !autospace_str
      autospace_str.gsub(/\%n/i, Demographics.name_and_nickname(enactor))
    end
    
    def self.add_to_scene(scene, pose, character = Game.master.system_character, is_setpose = nil, is_ooc = nil, place_name = nil)
      return nil if !scene.logging_enabled
      return nil if !pose
      
      scene_pose = ScenePose.create(pose: pose, character: character, scene: scene, is_setpose: is_setpose, is_ooc: is_ooc, place_name: place_name ? place_name : character.place_name(scene.room))
      if (!scene_pose.is_system_pose?)
        Scenes.add_participant(scene, character, character)
      end
      
      scene.mark_unread(character)
                  
      scene.update(last_activity: Time.now)
      pose_order_data = Scenes.build_pose_order_web_data(scene)
      
      notifications = {}
      
      scene.watchers.each do |p|
        AresCentral.play_screen_alts(p).each do |alt|
          next if notifications.has_key?(alt.id)
          data = Scenes.build_scene_pose_web_data(scene_pose, alt, true)
          data[:pose_order] = pose_order_data

          notifications[alt.id] = data
        end
      end
              
      # Can't use notify_web_clients here because the notification is different for each person.
      Global.dispatcher.spawn("Scene notification", nil) do
        clients = Global.client_monitor.clients
        clients.each do |client|
          char_id = client.web_char_id
          if (char_id && notifications.has_key?(char_id))
            web_msg = "#{scene.id}|#{character.name}|#{:new_pose}|#{notifications[char_id].to_json}"
            client.web_notify :new_scene_activity, web_msg, true
          end
        end
      end

      Scenes.create_new_pose_notification(scene, character.name)
            
      return scene_pose
    end
    
    def self.invite_to_scene(scene, char, enactor)
      if (!scene.invited.include?(char))
        scene.invited.add char
      end
      message = t('scenes.scene_notify_invite', :name => enactor.name, :num => scene.id)
      Login.emit_ooc_if_logged_in(char, message)        
      Login.notify(char, :scene, message, scene.id, "", false)
    end
    
    def self.uninvite_from_scene(scene, char, enactor)
      if (scene.invited.include?(char))
        scene.invited.delete char
      end
      Login.emit_ooc_if_logged_in(char, t('scenes.scene_notify_uninvited', :name => enactor.name, :num => scene.id))
    end
    
    def self.start_scene(enactor, location, private_scene, scene_type, temp_room)
      scene = Scene.create(owner: enactor, 
          location: location, 
          private_scene: private_scene,
          scene_type: scene_type,
          scene_pacing: Scenes.scene_pacing.first,
          temp_room: temp_room,
          last_activity: Time.now,
          icdate: ICTime.ictime.strftime("%Y-%m-%d"))

      Global.logger.info "Scene #{scene.id} started by #{enactor.name} in #{temp_room ? 'temp room' : enactor.room.name}."

      scene.watchers.add enactor
                
      if (temp_room)
        room = Scenes.create_scene_temproom(scene)
      else
        room = enactor.room
        room.update(scene: scene)
        room.update(pose_order: {})
        scene.update(room: room)
        room.emit_ooc t('scenes.announce_scene_start', :privacy => private_scene ? "Private" : "Open", :name => enactor.name, :num => scene.id)
      end
      

      scene_data = Scenes.build_live_scene_web_data(scene, enactor).to_json
      alts = AresCentral.play_screen_alts(enactor)
      Global.client_monitor.notify_web_clients(:joined_scene, scene_data, true) do |c|
        c && alts.include?(c)
      end
      
      return scene
    end
    
    def self.get_recent_scenes_web_data
      Scenes.recent_scenes[0..9].map { |s| {
                      id: s.id,
                      title: s.title,
                      summary: s.summary,
                      location: s.location,
                      content_warning: s.content_warning,
                      icdate: s.icdate,
                      participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: Website.icon_for_char(p) }},
                      scene_type: s.scene_type ? s.scene_type.titlecase : 'unknown',
                      scene_pacing: s.scene_pacing
      
                    }}
    end
    
    def self.build_web_profile_data(char, viewer)
      # Note: The scenes themselves come in a different request. This is just misc scene-related stats info.
      return {} if (char != viewer)
        
      words = char.pose_word_count
      scenes = char.scenes_participated_in.count
      if (words > 0 && scenes > 0)
        words_per_scene = ((words + 0.0) / scenes).round
      else
        words_per_scene = 0
      end
      {
        scene_stats: {
          pose_word_count: words,
          scenes_participated_in: scenes,
          words_per_scene: words_per_scene
        }
      }
    end
    
    def self.combat_started(scene, combat)
      Scenes.new_scene_activity(scene, :status_changed, nil)
    end
    
  end
end