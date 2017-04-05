module AresMUSH
  module Scenes
    def self.can_manage_scene(actor, scene)
      (scene.character == actor) || 
      actor.has_any_role?(Global.read_config("scenes", "can_manage_scenes"))
    end
    
    def self.is_valid_privacy(privacy)
      ["Public", "Private"].include?(privacy)
    end
  end
end
