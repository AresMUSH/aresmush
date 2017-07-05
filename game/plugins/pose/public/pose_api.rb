module AresMUSH
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
    def self.emit(enactor, pose, place_name = nil)
      Pose.emit_pose(enactor, pose, true, false, place_name)
    end
  end
end