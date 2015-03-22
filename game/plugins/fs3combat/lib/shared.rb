module AresMUSH
  module FS3Combat
    
    def self.combats
      CombatInstance.all
    end
    
    def self.is_in_combat?(name)
      !FS3Combat.combat(name).nil?
    end
    
    def self.combat(name)
      FS3Combat.combats.select { |c| c.has_combatant?(name) }.first
    end
  end
end