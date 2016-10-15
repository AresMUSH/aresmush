module AresMUSH
  module FS3Combat
    
    def self.combats
      Combat.all.sort { |c| c.num }.reverse
    end
    
    def self.combatant_types
      Global.read_config("fs3combat", "combatant_types")
    end
    
    def self.passenger_types
      [ "Pilot", "Passenger" ]
    end
    
    def self.is_in_combat?(name)
      !FS3Combat.combat(name).nil?
    end
    
    def self.combat(name)
      FS3Combat.combats.select { |c| c.has_combatant?(name) }.first
    end
    
    def self.combatant_type_stat(type, stat)
      type_config = FS3Combat.combatant_types[type]
      type_config[stat]
    end
    
    def self.with_a_combatant(name, client, enactor, &block)      
      if (!enactor.is_in_combat?)
        client.emit_failure t('fs3combat.you_are_not_in_combat')
        return
      end
      
      combat = enactor.combatant.combat
      combatant = combat.find_combatant(name)
      
      if (!combatant)
        client.emit_failure t('fs3combat.not_in_combat', :name => name)
        return
      end
      
      yield combat, combatant
    end
    
    def self.npcmaster_text(name, actor)
      return nil if !actor
      actor.name == name ? nil : t('fs3combat.npcmaster_text', :name => actor.name)
    end
  end
end