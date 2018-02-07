module AresMUSH
  module Scenes
    
    def self.emit(enactor, pose, place_name = nil)
      Scenes.emit_pose(enactor, pose, true, false, place_name)
    end
    
    def self.emit_setpose(enactor, pose)
      Scenes.emit_pose(enactor, pose, true, false, nil, true)
    end
    
    def self.colorize_quotes(enactor, pose, recipient)
      Scenes.custom_format(pose, recipient, enactor)
    end
    
    def self.add_to_scene(scene, pose, character = Game.master.system_character, is_setpose = nil, is_ooc = nil)
      return if !scene.logging_enabled
      
      scene_pose = ScenePose.create(pose: pose, character: character, scene: scene, is_setpose: is_setpose, is_ooc: is_ooc)
      if (!scene_pose.is_gm_pose? && !scene_pose.is_system_pose?)
        scene.participants.add character
      end
      
      scene.mark_unread(character)
      Scenes.new_scene_activity(scene)
    end
    
  end
end