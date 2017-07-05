module AresMUSH
  class Character
    def autospace
      self.pose_autospace
    end
    
    def autospace=(value)
      self.update(pose_autospace: value)
    end
  end
  
  class PoseEvent
    attr_accessor :enactor, :pose, :is_emit, :is_ooc, :is_setpose
    def initialize(enactor, pose, is_emit, is_ooc, is_setpose)
      @enactor = enactor
      @pose = pose
      @is_emit = is_emit
      @is_ooc = is_ooc
      @is_setpose = is_setpose
    end
  end
  
  module Pose
    module Api      
      def self.emit(enactor, pose, place_name = nil)
        Pose.emit_pose(enactor, pose, true, false, place_name)
      end
    end
  end
end