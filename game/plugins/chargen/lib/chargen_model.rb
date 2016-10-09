module AresMUSH
  class Character
    reference :background, "AresMUSH::Background"
    reference :chargen_info, "AresMUSH::ChargenInfo"
  end
  
  class Background < Ohm::Model
    include ObjectModel
    
    attribute :text
    reference :character, "AresMUSH::Character"
  end
  
  class ChargenInfo < Ohm::Model
    include ObjectModel
    
    attribute :locked, DataType::Boolean
    attribute :current_stage, DataType::Integer
    attribute :is_approved, DataType::Boolean
    reference :approval_job, "AresMUSH::Job"
    
    reference :character, "AresMUSH::Character"
  end
end