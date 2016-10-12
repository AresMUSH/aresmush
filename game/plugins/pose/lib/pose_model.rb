module AresMUSH

  class Character
    attribute :pose_nospoof, :type => DataType::Boolean
    attribute :pose_autospace, :default => "%r"
  end
  
  class PoseOrder < Ohm::Model
    include ObjectModel
    
    attribute :time, :type => DataType::Time

    reference :character, "AresMUSH::Character"
    reference :repose_info, "AresMUSH::ReposeInfo"
  end
  
  class ReposeInfo < Ohm::Model
    include ObjectModel
    
    reference :room, "AresMUSH::Room"
    
    attribute :poses, :type => DataType::Array
    collection :pose_orders, "AresMUSH::PoseOrder"
  end

  class Room
    reference :repose_info, "AresMUSH::ReposeInfo"
  end
  
  
end