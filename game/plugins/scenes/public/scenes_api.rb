module AresMUSH
  module Scenes
    
    def self.add_pose(scene, pose, character = Game.master.system_character, is_setpose = nil)
      return if !scene.logging_enabled
      scene_pose = ScenePose.create(pose: pose, character: character, scene: scene, is_setpose: is_setpose)
      if (!scene_pose.is_gm_pose? && !scene_pose.is_system_pose?)
        scene.participants.add character
      end
    end
    
    def self.can_manage_scene?(actor, scene)
      return false if !actor
      (scene.owner == actor) || 
      actor.has_permission?("manage_scenes")
    end
    
    
    def self.scene_types
      AresMUSH::Global.read_config('scenes', 'scene_types' )      
    end
    
    def self.can_access_scene?(actor, scene)
      return !scene.is_private? if !actor
      return true if Scenes.can_manage_scene?(actor, scene)
      return true if !scene.is_private?
      scene.participants.include?(actor)
    end
    
    
    def self.stop_scene(scene)
      return if scene.completed
      
      scene.room.characters.each do |c|
        connected_client = c.client
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

      scene.update(completed: true)
      scene.update(date_completed: Time.now)
    end
    
    def self.share_scene(scene)      
      scene.update(shared: true)
      scene.update(date_shared: Time.now)
      Scenes.create_or_update_log(scene)
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
        scene.room.update(name: "Scene #{scene.id} - #{location}")
        Describe.update_current_desc(scene.room, description)
      end
      
      return message
    end
  end
  
  class Room
    def logging_enabled?
      self.scene && self.scene.logging_enabled
    end
  end
  
end