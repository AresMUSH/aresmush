module AresMUSH
  class Character
    attribute :nospoof, DataType::Boolean
    attribute :autospace
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