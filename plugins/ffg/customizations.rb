module AresMUSH
  module Ffg
    
    def self.set_archetype_bonuses(model, type)
      # Any special archetype things can be set here.
    end
    
    def self.set_career_bonuses(model, career)
      # Any special career things can be set here.
    end
    
    def self.set_specialization_bonuses(model, spec)
      # Any special specialization things can be set here.
      
      if (Ffg.use_force? && Ffg.is_force_user?(model) && !model.is_approved?)
        model.update(ffg_force_rating: 1)
      end
    end
  end
end