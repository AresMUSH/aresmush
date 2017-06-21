module AresMUSH
  module Scenes
    module Api
      def self.add_pose(scene_id, pose, character = Game.master.system_character)
        Scenes.add_pose(scene_id, pose, character)
      end
      
      def self.reset_poses(scene_id)
        Scenes.reset_poses(scene_id)
      end
    end
  end
end