module AresMUSH
  class Character
    def autospace
      self.pose_autospace
    end
    
    def autospace=(value)
      self.update(pose_autospace: value)
    end
  end
  
  class Room
    def repose_on?
      Pose.repose_enabled && self.repose_info && self.repose_info.enabled
    end
  end
  
  
  module Pose
    module Api
      def self.reset_repose(room)
        Pose.reset_repose(room)
      end
    end
  end
  
  class PoseEvent
    attr_accessor :enactor, :pose, :is_emit
    def initialize(enactor, pose, is_emit)
      @enactor = enactor
      @pose = pose
      @is_emit = is_emit
    end
  end
end