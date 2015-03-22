module AresMUSH
  class Character
    field :treat_skill, :type => String
    has_one :combatant
    has_many :damage, :dependent => :destroy
    
    def treatable_wounds
      self.damage.select { |d| d.is_treatable? }
    end
    
    def unhealed_wounds
      self.damage.select { |d| d.healing_points > 0 } 
    end
  end
end