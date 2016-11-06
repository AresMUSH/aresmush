module AresMUSH

  class Character
    attribute :pose_nospoof, :type => DataType::Boolean
    attribute :pose_autospace, :default => "%r"
    attribute :pose_quote_color
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
    
    attribute :poses, :type => DataType::Array, :default => []
    attribute :enabled, :type => DataType::Boolean, :default => true
    collection :pose_orders, "AresMUSH::PoseOrder"
    
    def reset
      pose_orders.each { |po| po.delete }
      self.update(poses: [])
    end
  end

  class Room
    reference :repose_info, "AresMUSH::ReposeInfo"
    
    def repose_on?
      self.repose_info && self.repose_info.enabled
    end
  end
  
  
end