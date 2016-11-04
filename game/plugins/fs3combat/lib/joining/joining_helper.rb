module AresMUSH
  module FS3Combat
    
    def self.find_combat_by_number(client, num)
      num_str = "#{num}"

      if (!num_str.is_integer?)
        client.emit_failure t('fs3combat.invalid_combat_number')
        return nil
      end
      
      match = Combat[num.to_i]

      if (!match)
        client.emit_failure t('fs3combat.invalid_combat_number')
        return nil
      end
      
      return match
    end
    
    def self.join_combat(combat, name, combatant_type, enactor, client)
      if FS3Combat.is_in_combat?(name)
        client.emit_failure t('fs3combat.already_in_combat', :name => name) 
        return nil
      end
      
      result = ClassTargetFinder.find(name, Character, enactor)
      if (result.found?)
        combatant = Combatant.create(:combatant_type => combatant_type, 
          :character => result.target,
          :team => 1,
          :combat => combat)
      else
        npc = Npc.create(name: name)
        combatant = Combatant.create(:combatant_type => combatant_type, 
        :npc => npc,
        :team =>  2,
        :combat => combat)
      end
      combat.emit t('fs3combat.has_joined', :name => name, :type => combatant_type)
      
      vehicle_type = FS3Combat.combatant_type_stat(combatant_type, "vehicle")
      
      if (vehicle_type)
        vehicle = FS3Combat.find_or_create_vehicle(combat, vehicle_type)
        FS3Combat.join_vehicle(combat, combatant, vehicle, "Pilot")
      else
        FS3Combat.set_default_gear(enactor, combatant, combatant_type)
      end
      
      return combatant
    end
        
    def self.leave_combat(combat, combatant)
      combat.emit t('fs3combat.has_left', :name => combatant.name)
      combatant.delete
    end
  end
end