module AresMUSH
  class Character
    attribute :cg_background
    attribute :is_approved, :type => DataType::Boolean
    attribute :chargen_locked, :type => DataType::Boolean
    attribute :chargen_stage, :type => DataType::Integer
    reference :approval_job, "AresMUSH::Job"
  end
end