module AresMUSH
  module Scenes
    def self.can_manage_scene(actor, scene)
      return false if !actor
      (scene.owner == actor) || 
      actor.has_permission?("manage_scenes")
    end
    
    def self.is_valid_privacy?(privacy)
      ["Public", "Private"].include?(privacy)
    end
    
    def self.scene_types
      AresMUSH::Global.read_config('scenes', 'scene_types' )      
    end
    
    def self.can_access_scene?(actor, scene)
      return true if Scenes.can_manage_scene(actor, scene)
      return true if !scene.is_private?
      return scene.participants.include?(actor)
    end
    
    def self.with_a_scene(scene_id, client, &block)
      scene = Scene[scene_id]
      if (!scene)
        client.emit_failure t('scenes.scene_not_found')
        return
      end
      
      yield scene
    end
    
    def self.stop_scene(scene)
      return if scene.completed
      
      scene.room.characters.each do |c|
        connected_client = c.client
        if (connected_client)
          connected_client.emit_ooc t('scenes.scene_ending')
        end
        
        if (scene.temp_room)
          Rooms::Api.send_to_ooc_room(connected_client, c)
        end
      end
      
      if (scene.temp_room)
        scene.room.delete
      else
        scene.room.update(scene: nil)
        scene.update(room: nil)
      end
      
      if (!scene.private_scene)
        scene.update(shared: true)
      end
      scene.update(completed: true)
    end
    
    def self.add_pose(scene, pose, character = Game.master.system_character)
      return if !scene.logging_enabled
      scene_pose = ScenePose.create(pose: pose, character: character, scene: scene)
    end
  end
end
