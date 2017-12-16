module AresMUSH
  module Pose
    def self.emit(enactor, pose, place_name = nil)
      Pose.emit_pose(enactor, pose, true, false, place_name)
    end
    
    def self.emit_setpose(enactor, pose)
      Pose.emit_pose(enactor, pose, true, false, nil, true)
    end
    
    def self.colorize_quotes(enactor, pose, recipient)
      Pose.custom_format(pose, recipient, enactor)
    end
  end
end