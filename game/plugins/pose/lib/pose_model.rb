module AresMUSH

  class Character
    reference :pose_prefs, "AresMUSH::PosePrefs"
  end
  
  class PosePrefs < Ohm::Model
    include ObjectModel
    
    attribute :nospoof, DataType::Boolean
    attribute :autospace
    
    reference :character, "AresMUSH::Character"
  end
  
  class PoseOrder < Ohm::Model
    include ObjectModel
    
    attribute :time, DataType::Time

    reference :character, "AresMUSH::Character"
    reference :repose_info, "AresMUSH::ReposeInfo"
    
    index :time
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