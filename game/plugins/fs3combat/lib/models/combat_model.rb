module AresMUSH
  class Character
    attribute :last_treated, :type => Time
    
    reference :combatant, "AresMUSH::Combatant"
    collection :damage, "AresMUSH::Damage"
    
    before_delete :delete_damage
    
    def delete_damage
      self.damage.each { |d| d.delete }
    end
    
    def treatable_wounds
      self.damage.select { |d| d.is_treatable? }
    end
    
    def unhealed_wounds
      self.damage.select { |d| d.healing_points > 0 } 
    end
    
    def can_be_treated?
      return true if !self.last_treated
      time_to_go = 300 - (Time.now - self.last_treated)
      return true if time_to_go < 0
      return false
    end
    
    def is_in_combat?
      combatant
    end
  end
end