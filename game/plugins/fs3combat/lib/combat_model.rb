module AresMUSH
  class Character
    
    # current_severity (L/M/S/C)
    # initial_severity (L/M/S/C)
    # time
    # desc
    # last_treated
    # healing_points
    # is_stun
    field :combat_damage, :type => Array, :default => []
    
    field :treat_skill, :type => String
    
    field :last_treated, :type => Time
  end
end