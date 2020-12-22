module AresMUSH
  module Scenes
    
    def self.create_scene_temproom(scene)
      room = Room.create(scene: scene, room_type: "RPR", name: "Scene #{scene.id}")
      ex = Exit.create(name: "O", source: room, dest: Game.master.ooc_room)
      scene.update(room: room)
      scene.update(temp_room: true)
      Scenes.set_scene_location(scene, scene.location)
      room
    end
    
    def self.restart_scene(scene)
      Scenes.create_scene_temproom(scene)
      scene.update(completed: false)
      scene.update(was_restarted: true)
      scene.update(last_activity: Time.now)
      scene.update(deletion_warned: false)
      scene.watchers.replace scene.participants.to_a
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

      # Can't use the regular notify method because of watcher race condition
      web_msg = "#{scene.id}||#{:status_changed}|"
      watchers = scene.watchers.map { |c| c.id }
      Global.client_monitor.notify_web_clients(:new_scene_activity, web_msg, true) do |char|
        Scenes.can_read_scene?(char, scene) && char && watchers.include?(char.id)
      end
      
      scene.invited.replace []
      scene.watchers.replace []
      
      scene.participants.each do |char|
        # Don't double-award luck or scene participation if we've already tracked 
        # that they've participated in that scene.
        if (!Scenes.participated_in_scene?(char, scene))
          Scenes.handle_scene_participation_achievement(char, scene)
          if (FS3Skills.is_enabled?)
            FS3Skills.luck_for_scene(char, scene)
          end
        end
      end
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
    
    def self.report_scene(enactor, scene, reason)
      log = ""
      scene.scene_poses.to_a.sort_by { |p| p.sort_order }.each do |pose|
        name = pose.character.name
        ooc = pose.is_ooc ? "<OOC> " : ""
        text = pose.is_deleted? ? "<DELETED> #{pose.pose}" : pose.pose
        history = pose.history.any? ? "%R%T*** Prior Versions: #{pose.history.join("%R%T")}" : ""

        log << "%R%R#{ooc}#{text} (by #{name}) #{history}"
      end

      body = t('scenes.scene_reported_body', :scene_num => scene.id, :reporter => enactor.name)
      body << reason
      body << "%R-------%R"
      body << log

      Jobs.create_job(Jobs.trouble_category, t('scenes.scene_reported_title'), body, Game.master.system_character)
    end
    
    def self.handle_scene_command(pose, enactor, char, scene)
      command = pose.after("/").before(" ")
      args = pose.after(" ")

      custom = CustomSceneCommands.new
      message = custom.handle(enactor, char, scene, command, args)
      if (message)
        return message
      end
      
      parser = Scenes::BaseSceneCommands.new
      message = parser.handle(enactor, char, scene, command, args)
      return message
    end
    
  end
end