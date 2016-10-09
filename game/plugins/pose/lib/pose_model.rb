module AresMUSH

  class Character
    attribute :pose_nospoof, DataType::Boolean
    attribute :autospace
    
    before_create :set_default_autospace
    
    def set_default_autospace
      self.autospace = "%r"
    end
  end
  
  class PoseOrder < Ohm::Model
    include ObjectModel
    
    attribute :time, DataType::Time

    reference :character, "AresMUSH::Character"
    reference :repose_info, "AresMUSH::ReposeInfo"
  end
  
  class ReposeInfo < Ohm::Model
    include ObjectModel
    
    reference :room, "AresMUSH::Room"
    
    attribute :poses, DataType::Array
    collection :pose_orders, "AresMUSH::PoseOrder"
  end

  class Room
    reference :repose_info, "AresMUSH::ReposeInfo"
  end
  
  
end