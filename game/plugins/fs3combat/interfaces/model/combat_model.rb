module AresMUSH
  class Character
    field :treat_skill, :type => String
    field :last_treated, :type => Time
    
    has_one :combatant
    has_many :damage, :dependent => :destroy
    
    def treatable_wounds
      self.damage.select { |d| d.is_treatable? }
    end
    
    def unhealed_wounds
      self.damage.select { |d| d.healing_points > 0 } 
    end
    
    def can_treat?
      return true if self.last_treated.nil?
      time_to_go = 300 - (Time.now - self.last_treated)
      return true if time_to_go < 0
      return false
    end
    
    def is_in_combat?
      !combatant.nil?
    end
  end
end