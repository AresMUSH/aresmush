module AresMUSH
  class Character
    attribute :nospoof, DataType::Boolean
    attribute :autospace
    
    before_create :set_default_pose_attributes
    
    def set_default_pose_attributes
      self.autospace = "%r"
    end
  end

  class Room
    attribute :repose_on, DataType::Boolean
    set :poses, "AresMUSH::SimpleData"
    set :pose_order, "AresMUSH::PoseOrder"
  end
  
  class PoseOrder < Ohm::Model
    include ObjectModel
    
    attribute :pose
    attribute :time, DataType::Time
  end
  
end