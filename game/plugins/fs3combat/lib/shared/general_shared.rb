module AresMUSH
  module FS3Combat
    
    def self.combats
      CombatInstance.all.sort { |c| c.num }.reverse
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
    
    def self.combatant_type_stat(type, stat)
      type_config = FS3Combat.combatant_types[type]
      type_config[stat]
    end
    
    def self.find_combat_by_number(client, num)
      num_str = "#{num}"
      
      if (!num_str.is_integer?)
        client.emit_failure t('fs3combat.invalid_combat_number')
        return nil
      end
      
      match = FS3Combat.combats.select { |c| c.num == num_str.to_i }.first

      if (!match)
        client.emit_failure t('fs3combat.invalid_combat_number')
        return nil
      end
      
      return match
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
      actor.name == name ? nil : t('fs3combat.npcmaster_text', :name => actor.name)
    end
  end
end