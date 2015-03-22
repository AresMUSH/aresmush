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
  end
end