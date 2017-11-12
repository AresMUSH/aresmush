module AresMUSH
  module FS3Combat
    
    def self.roll_attack(combatant, mod = 0)
      ability = FS3Combat.weapon_stat(combatant.weapon, "skill")
      accuracy_mod = FS3Combat.weapon_stat(combatant.weapon, "accuracy")
      special_mod = combatant.attack_mod
      damage_mod = combatant.total_damage_mod
      stance_mod = combatant.attack_stance_mod
      stress_mod = combatant.stress
      aiming_mod = (combatant.is_aiming? && (combatant.aim_target == combatant.action.target)) ? 3 : 0
      luck_mod = (combatant.luck == "Attack") ? 3 : 0
      distraction_mod = combatant.distraction

      combatant.log "Attack roll for #{combatant.name} ability=#{ability} aiming=#{aiming_mod} mod=#{mod} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod} luck=#{luck_mod} stress=#{stress_mod} special=#{special_mod} distract=#{distraction_mod}"

      mod = mod + accuracy_mod + damage_mod + stance_mod + aiming_mod + luck_mod - stress_mod + special_mod - distraction_mod
      
      
      combatant.roll_ability(ability, mod)
    end
    
    def self.roll_defense(combatant, attacker_weapon)
      ability = FS3Combat.weapon_defense_skill(combatant, attacker_weapon)
      stance_mod = combatant.defense_stance_mod
      luck_mod = (combatant.luck == "Defense") ? 3 : 0
      damage_mod = combatant.total_damage_mod
      special_mod = combatant.defense_mod
      dodge_mod = FS3Combat.vehicle_dodge_mod(combatant)
      distraction_mod = combatant.distraction
      
      mod = stance_mod + luck_mod + damage_mod + special_mod + dodge_mod - distraction_mod
      
      combatant.log "Defense roll for #{combatant.name} ability=#{ability} stance=#{stance_mod} damage=#{damage_mod} luck=#{luck_mod} special=#{special_mod} dodge=#{dodge_mod} distract=#{distraction_mod}"
      
      combatant.roll_ability(ability, mod)
    end
    
    # Attacker           |  Defender            |  Skill
    # -------------------|----------------------|----------------------------
    # Any weapon         |  In Vehicle          |  Vehicle piloting skill
    # Melee weapon       |  Melee weapon        |  Defender's weapon skill
    # Melee weapon       |  Other weapon        |  Default combatant type skill
    # Other weapon       |  Other weapon        |  Default combatant type skill
    def self.weapon_defense_skill(combatant, attacker_weapon)
      if (combatant.is_in_vehicle?)
        return FS3Combat.vehicle_stat(combatant.vehicle.vehicle_type, "pilot_skill")
      end
      
      attacker_weapon_type = FS3Combat.weapon_stat(attacker_weapon, "weapon_type").titlecase
      defender_weapon_type = FS3Combat.weapon_stat(combatant.weapon, "weapon_type").titlecase
      if (attacker_weapon_type == "Melee" && defender_weapon_type == "Melee")
        skill = FS3Combat.weapon_stat(combatant.weapon, "skill")
      else
        skill = FS3Combat.combatant_type_stat(combatant.combatant_type, "defense_skill") ||
                Global.read_config("fs3combat", "default_defense_skill")
      end
      skill
    end
    
    def self.hitloc_chart(combatant, crew_hit = false)
      vehicle = combatant.vehicle
      if (!crew_hit && vehicle)
        hitloc_type = vehicle.hitloc_type
      else
        hitloc_type = FS3Combat.combatant_type_stat(combatant.combatant_type, "hitloc")
      end
      FS3Combat.hitloc_chart_for_type(hitloc_type)
    end
    
    def self.hitloc_areas(combatant, crew_hit = false)
      FS3Combat.hitloc_chart(combatant, crew_hit)["areas"]
    end
    
    def self.has_hitloc?(combatant, hitloc, crew_hit = false)
      hitlocs = FS3Combat.hitloc_areas(combatant, crew_hit)
      hitlocs.keys.map { |h| h.titlecase }.include?(hitloc.titlecase)
    end
    
    def self.hitloc_severity(combatant, hitloc, crew_hit = false)
      hitloc_chart = FS3Combat.hitloc_chart(combatant, crew_hit)
      vital_areas = hitloc_chart["vital_areas"]
      crit_areas = hitloc_chart["critical_areas"]
      
      return "Vital" if vital_areas.map { |v| v.titlecase }.include?(hitloc.titlecase)
      return "Critical" if crit_areas.map { |c| c.titlecase }.include?(hitloc.titlecase)
      return "Normal"
    end
    
    def self.determine_hitloc(combatant, attacker_net_successes, called_shot = nil, crew_hit = nil)
      return called_shot if (called_shot && attacker_net_successes > 2)

      hitloc_chart = FS3Combat.hitloc_areas(combatant, crew_hit)
            
      if (called_shot)
        locations = hitloc_chart[called_shot]
      else
        locations = hitloc_chart[hitloc_chart.keys.first]
      end
      
      roll = rand(locations.count) + attacker_net_successes
      roll = [roll, locations.count - 1].min
      roll = [0, roll].max
      locations[roll]
    end    
      
    def self.roll_initiative(combatant, ability)
      luck_mod = combatant.luck == "Initiative" ? 3 : 0
      action_mod = 0
      if (combatant.action_klass == "AresMUSH::FS3Combat::SuppressAction" ||
          combatant.action_klass == "AresMUSH::FS3Combat::DistractAction" || 
          combatant.action_klass == "AresMUSH::FS3Combat::SubdueAction")
          action_mod = 3
      end
      weapon_mod = FS3Combat.weapon_stat(combatant.weapon, "init_mod") || 0
      roll = combatant.roll_ability(ability, weapon_mod + action_mod + luck_mod + combatant.total_damage_mod)

      combatant.log "Initiative roll for #{combatant.name} ability=#{ability} action=#{action_mod} weapon=#{weapon_mod} luck=#{luck_mod} roll=#{roll}"
 
      roll
    end
    
    def self.check_ammo(combatant, bullets)
      return true if combatant.max_ammo == 0
      combatant.ammo >= bullets
    end
    
    def self.update_ammo(combatant, bullets)
      return nil if combatant.max_ammo == 0

      ammo = combatant.ammo - bullets
      combatant.update(ammo: ammo)
      
      if (ammo == 0)
        t('fs3combat.weapon_clicks_empty', :name => combatant.name)
      else
        nil
      end
    end
  end
end