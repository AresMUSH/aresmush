module AresMUSH
  module FS3Combat
    
    def self.find_combat_by_number(client, num)
      num_str = "#{num}"
      
      if (!num_str.is_integer?)
        client.emit_failure t('fs3combat.invalid_combat_number')
        return nil
      end
      
      match = Combat[num]

      if (!match)
        client.emit_failure t('fs3combat.invalid_combat_number')
        return nil
      end
      
      return match
    end
    
    def self.join_combat(combat, name, combatant_type, char = nil)
      combatant = Combatant.create(:name => name, 
        :combatant_type => combatant_type, 
        :character => char,
        :team => char ? 1 : 2,
        :combat => combat)
      emit t('fs3combat.has_joined', :name => name, :type => combatant_type)
      return combatant
    end
        
    def self.leave_combat(combat, name)
      emit t('fs3combat.has_left', :name => name)
      combatant = combat.find_combatant(name)
      combatant.delete
    end
    
    
    
  end
end