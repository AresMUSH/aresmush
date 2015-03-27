module AresMUSH
  module FS3Combat
    
    def self.combats
      CombatInstance.all.sort { |c| c.created_at }
    end
    
    def self.combatant_types
      Global.config["fs3combat"]["combatant_types"]
    end
    
    def self.is_in_combat?(name)
      !FS3Combat.combat(name).nil?
    end
    
    def self.combat(name)
      FS3Combat.combats.select { |c| c.has_combatant?(name) }.first
    end
    
    def self.find_combat_by_number(client, num)
      num_str = "#{num}"
      
      if (!num_str.is_integer?)
        client.emit_failure t('fs3combat.invalid_combat_number')
        return nil
      end
      
      index = num_str.to_i - 1
      if (index < 0 || index >= FS3Combat.combats.count)
        client.emit_failure t('fs3combat.invalid_combat_number')
        return nil
      end
      
      return FS3Combat.combats[index]
    end
    
    def self.with_a_combatant(name, client, &block)
      combat = FS3Combat.combat(name)
      if (!combat)
        client.emit_failure t('fs3combat.not_in_combat', :name => name)
        return
      end
      
      combatant = combat.find_combatant(name)
      
      yield combat, combatant
    end
    
    def self.npcmaster_text(name, actor)
      actor.name == name ? nil : actor.name
    end
  end
end