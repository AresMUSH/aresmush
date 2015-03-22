module AresMUSH
  module FS3Combat
    # Array of combat objects. 
    mattr_accessor :combats
    
    def self.is_in_combat?(name)
      !FS3Combat.combat(name).nil?
    end
    
    def self.combat(name)
      FS3Combat.combats.select { |c| c.has_combatant?(name) }.first
    end
  end
end