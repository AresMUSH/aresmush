module AresMUSH
  class Character
    field :xp, :type => Integer, :default => 0
    field :last_xp_spend, :type => Time
  end
end