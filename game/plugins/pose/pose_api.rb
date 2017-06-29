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
    attr_accessor :enactor, :pose, :is_emit
    def initialize(enactor, pose, is_emit)
      @enactor = enactor
      @pose = pose
      @is_emit = is_emit
    end
  end
end