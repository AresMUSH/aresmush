module AresMUSH
  class Character
    attribute :is_approved, DataType::Boolean
    attribute :chargen_locked, DataType::Boolean
    attribute :chargen_stage, DataType::Integer
    attribute :background
    
    reference :approval_job, "AresMUSH::Job"
  end
end