module AresMUSH
  module Scenes
    module Api
      def self.add_pose(scene_id, pose, character = Game.master.system_character)
        Scenes.add_pose(scene_id, pose, character)
      end
      
      def self.reset_poses(scene_id)
        Scenes.reset_poses(scene_id)
      end
      
      def self.get_log(scene_id, actor)
        Scenes.get_log(scene_id, actor)
      end
    end
  end
  
  class SceneLog
    attr_accessor :id, :title, :location, :participants, :poses, :summary, :ictime
  end
  
  class SceneLogPose
    attr_accessor :character, :is_system, :pose
    
    def initialize(scene_pose)
      @character = scene_pose.character
      @is_system = scene_pose.is_system_pose?
      @pose = scene_pose.pose
    end
  end
  
  class Room
    def repose_on?
      self.repose_info && self.repose_info.enabled
    end
  end
  
  
  module Scenes
    module Api
      def self.reset_repose(room)
        Pose.reset_repose(room)
      end
      
      def self.enable_repose(room)
        Pose.enable_repose(room)
      end
      
      def self.emit(enactor, pose, place_name = nil)
        Pose.emit_pose(enactor, pose, true, false, place_name)
      end
    end
  end
  
  
end