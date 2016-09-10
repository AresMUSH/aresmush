module AresMUSH
  class Character
    field :chargen_locked, :type => Boolean, :default => false
    field :chargen_stage, :type => Integer, :default => 0
    field :background, :type => String
    
    has_one :approval_job, :class_name => 'AresMUSH::Job', :inverse_of => :approval_char
  end
end