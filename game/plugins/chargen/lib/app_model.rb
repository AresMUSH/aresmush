module AresMUSH
  class Character
    field :chargen_locked, :type => Boolean, :default => false
    field :chargen_stage, :type => Integer, :default => 0
  end
end