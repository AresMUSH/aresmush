module AresMUSH
  class Character
    has_one :approval_job, :class_name => 'AresMUSH::Job', :inverse_of => :approval_char

    field :background, :type => String
  end
end