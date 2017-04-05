module AresMUSH
  module Scenes
    def self.can_manage_scene(actor, scene)
      (scene.owner == actor) || 
      actor.has_permission?("manage_scenes")
    end
    
    def self.is_valid_privacy(privacy)
      ["Public", "Private"].include?(privacy)
    end
  end
end
