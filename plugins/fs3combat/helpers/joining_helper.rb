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
    
    # client may be nil from web
    def self.join_combat(combat, name, combatant_type, enactor, client)
      result = ClassTargetFinder.find(name, Character, enactor)
      if (result.found?)
        
        char = result.target
        name = char.name
        
        if FS3Combat.is_in_combat?(name)
          client.emit_failure t('fs3combat.already_in_combat', :name => name)  if client
          return nil
        end
      
        combatant = Combatant.create(:combatant_type => combatant_type, 
          :character => char,
          :team => 1,
          :combat => combat)
          FS3Combat.handle_combat_join_achievement(char)
      else
        
        if FS3Combat.is_in_combat?(name)
          client.emit_failure t('fs3combat.already_in_combat', :name => name)  if client
          return nil
        end
      
        npc = Npc.create(name: name, combat: combat, level: FS3Combat.default_npc_type)
        combatant = Combatant.create(:combatant_type => combatant_type, 
        :npc => npc,
        :team =>  9,
        :combat => combat)
      end
      FS3Combat.emit_to_combat combat, t('fs3combat.has_joined', :name => name, :type => combatant_type)
      
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
      FS3Combat.emit_to_combat combat, t('fs3combat.has_left', :name => combatant.name)
      combatant.delete
    end
    
    def self.handle_combat_join_achievement(char)
      char.update(combats_participated_in: char.combats_participated_in + 1)
      [ 1, 10, 20, 50, 100 ].reverse.each do |count|
        if (char.combats_participated_in >= count)
          Achievements.award_achievement(char, "fs3_joined_combat", count)
          break
        end
      end
    end
  end
end