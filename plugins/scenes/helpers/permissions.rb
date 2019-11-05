module AresMUSH
  module Scenes
    
    def self.can_manage_scene?(actor, scene)
      return false if !actor
      actor.has_permission?("manage_scenes")
    end
    
    def self.can_control_npcs?(actor)
      return false if !actor
      actor.has_permission?("control_npcs")
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
    
    def self.can_pose_char?(actor, char)
      return true if char == actor
      return true if AresCentral.is_alt?(actor, char)
      (char.is_npc? && Scenes.can_control_npcs?(actor))
    end
    
  end
end
