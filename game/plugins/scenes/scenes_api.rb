module AresMUSH
  module Scenes
    module Api
      def self.add_pose(scene, pose, character = Game.master.system_character)
        Scenes.add_pose(scene, pose, character)
      end  
      
      def self.can_access_scene?(actor, scene)
        Scenes.can_access_scene?(actor, scene)
      end
    end
  end
  
  class Room
    def logging_enabled?
      self.scene && self.scene.logging_enabled
    end
  end
  
end