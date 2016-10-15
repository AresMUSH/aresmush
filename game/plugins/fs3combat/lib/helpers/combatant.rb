module AresMUSH
  module FS3Combat
    
    def self.roll_attack(combatant, mod = 0)
      ability = FS3Combat.weapon_stat(combatant.weapon, "skill")
      accuracy_mod = FS3Combat.weapon_stat(combatant.weapon, "accuracy")
      damage_mod = total_damage_mod
      stance_mod = attack_stance_mod
      aiming_mod = (combatant.is_aiming && (combatant.aim_target == combatant.action.print_target_names)) ? 3 : 0
      luck_mod = (combatant.luck == "Attack") ? 3 : 0
      mod = mod + accuracy_mod - damage_mod + stance_mod + aiming_mod + luck_mod
      
      Global.logger.debug "Attack roll for #{combatant.name} ability=#{ability} aiming=#{aiming_mod} mod=#{mod} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod} luck=#{luck_mod}"
      
      FS3Combat.roll_ability(combatant, ability, mod)
    end
    
    def self.roll_defense(combatant, attacker_weapon)
      ability = FS3Combat.weapon_defense_skill(combatant, attacker_weapon)
      stance_mod = defense_stance_mod
      luck_mod = (combatant.luck == "Defense") ? 3 : 0
      mod = 0 - total_damage_mod + stance_mod + luck_mod
      
      Global.logger.debug "Defense roll for #{combatant.name} ability=#{ability} stance=#{stance_mod} luck=#{luck_mod}"
      
      FS3Combat.roll_ability(combatant, ability, mod)
    end
    
    # Attacker           |  Defender            |  Skill
    # -------------------|----------------------|----------------------------
    # Any weapon         |  Pilot type          |  Pilot's vehicle skill
    # Any weapon         |  Passenger type      |  Pilot's vehicle skill
    # Melee weapon       |  Melee weapon        |  Defender's weapon skill
    # Melee weapon       |  Other weapon        |  Default combatant type skill
    # Other weapon       |  Other weapon        |  Default combatant type skill
    def self.weapon_defense_skill(combatant, attacker_weapon)
      # TODO - pilot and passenger vehicle skills
      attacker_weapon_type = FS3Combat.weapon_stat(attacker_weapon, "weapon_type").titleize
      defender_weapon_type = FS3Combat.weapon_stat(combatant.weapon, "weapon_type").titleize
      if (attacker_weapon_type == "Melee" && defender_weapon_type == "Melee")
        skill = FS3Combat.weapon_stat(combatant.weapon, "skill")
      else
        skill = FS3Combat.combatant_type_stat(combatant.combatant_type, "defense_skill")
      end
      skill
    end
    
    def self.hitloc_chart(combatant)
      # TODO - If combatant is pilot or passenger, use their vehicle's hitloc chart
      #  except for crew hits - maybe pass in a crew_hit bool?
      hitloc_type = FS3Combat.combatant_type_stat(combatant.combatant_type, "hitloc")
      FS3Combat.hitloc(hitloc_type)["areas"]
    end
    
    def self.hitloc_severity(combatant, hitloc)
      hitloc_type = FS3Combat.combatant_type_stat(combatant.combatant_type, "hitloc")
      hitloc_data = FS3Combat.hitloc(hitloc_type)
      vital_areas = hitloc_data["vital_areas"]
      crit_areas = hitloc_data["critical_areas"]
      
      return "Vital" if vital_areas.map { |v| v.titleize }.include?(hitloc.titleize)
      return "Critical" if crit_areas.map { |c| c.titleize }.include?(hitloc.titleize)
      return "Normal"
    end
    
    def self.determine_hitloc(combatant, successes)
      hitloc_chart = FS3Combat.hitloc_chart(combatant)
      roll = rand(hitloc_chart.count) + successes
      roll = [roll, hitloc_chart.count - 1].min
      roll = [0, roll].max
      hitloc_chart[roll]
    end
    
    def self.roll_ability(combatant, ability, mod = 0)
      if (combatant.is_npc?)
        result = FS3Skills::Api.one_shot_die_roll(combatant.npc_skill + mod)
      else
        params = FS3Skills::RollParams.new(ability, mod)
        result = FS3Skills::Api.one_shot_roll(nil, combatant.character, params)
      end
      result[:successes]
    end
      
    def self.roll_initiative(combatant, ability)
      luck_mod = combatant.luck == "Initiative" ? 3 : 0
      roll1 = roll_ability(ability, -combatant.total_damage_mod)  # TODO move total damage mod / refactor damage
      roll2 = roll_ability(ability, -combatant.total_damage_mod)
      roll1 + roll2 + luck_mod
    end
    
    def self.do_damage(combatant, severity, weapon, hitloc)
      if (combatant.is_npc?)
        combatant.npc_damage << severity
      else
        desc = "#{weapon} - #{hitloc}"
        is_stun = FS3Combat.weapon_is_stun?(weapon)
        FS3Combat.inflict_damage(combatant.character, severity, desc, is_stun, !combatant.combat.is_real)
      end
    end
    
    
    def update_ammo(combatant, bullets)
      if (combatant.ammo)
        combatant.ammo = combatant.ammo - bullets
        
        if (combatant.ammo == 0)
          t('fs3combat.weapon_clicks_empty', :name => combatant.name)
        else
          nil
        end
      end
    end
    
    
    def self.determine_armor(combatant, hitloc, weapon)
      # TODO - If pilot or passenger, use vehicle armor
      
      # Not wearing armor at all.
      return 0 if !combatant.armor
      
      pen = FS3Combat.weapon_stat(weapon, "penetration")
      protect = FS3Combat.armor_stat(combatant.armor, "protection")[hitloc]
      
      # Armor doesn't cover this hit location
      return 0 if !protect

      pen_ratio = pen / protect
      
      # No coverage if penetration is way higher than armor value.
      return 0 if pen_ratio > 2
      
      # Full coverage if protection way higher than penetration
      return 100 if pen_ratio < 0.5
       
      # Ratio is between 0.5 (good) and 2 (bad).  Dividing a rand number by
      # that value will give us a number from 50-200.
      return rand(100) / pen_ratio
    end
    
    def self.determine_damage(combatant, hitloc, weapon, armor = 0)
      random = rand(100)
      
      lethality = FS3Combat.weapon_stat(weapon, "lethality")
      
      case FS3Combat.hitloc_severity(combatant, hitloc)
      when "Critical"
        severity = 30
      when "Vital"
        severity = 15
      else
        severity = 0
      end
      
      total = random + severity + lethality - armor
      
      if (total < 41)
        damage = "L"
      elsif (total < 81)
        damage = "M"
      elsif (total <100)
        damage = "S"
      else
        damage = "C"
      end
      
      Global.logger.info "Determined damage: loc=#{hitloc} sev=#{severity} wpn=#{weapon}" +
      " lth=#{lethality} arm=#{armor} rand=#{random} total=#{total} dmg=#{damage}"
      
      damage
    end
    
    def self.attack_target(combatant, target, called_shot = nil, mod = 0)
      attack_roll = FS3Combat.roll_attack(combatant, mod - combatant.recoil)
      defense_roll = target.roll_defense(combatant.weapon)
            
      # Margin of success for the attacker
      margin = attack_roll - defense_roll
            
      if (attack_roll <= 0)
        message = t('fs3combat.attack_missed', :name => combatant.name, :target => target.name)

      elsif (defense_roll > attack_roll)
        message = t('fs3combat.attack_dodged', :name => combatant.name, :target => target.name)

      elsif (target.stance == "Cover" && margin < 2 && rand(100) < 60)
        message = t('fs3combat.attack_hits_cover', :name => combatant.name, :target => target.name)

      else
                  
        # Called shot either hits the desired location, or chooses a random location
        # at a penalty for missing.
        if (called_shot)
          if (margin > 2)
            hitloc = called_shot
          else
            hitloc = target.determine_hitloc(margin - 2)
          end
        else
          hitloc = target.determine_hitloc(margin)
        end
        
        armor = target.determine_armor(hitloc, combatant.weapon)
        
        if (armor >= 100)
          message = t('fs3combat.attack_stopped_by_armor', :name => combatant.name, :target => target.name, :hitloc => hitloc)
        else
          
          reduced_by_armor = armor > 0 ? t('fs3combat.reduced_by_armor') : ""
          
          damage = target.determine_damage(hitloc, combatant.weapon, armor)
          target.do_damage(damage, combatant.weapon, hitloc)
          message = t('fs3combat.attack_hits', 
            :name => combatant.name, 
            :target => target.name,
            :hitloc => hitloc,
            :armor => reduced_by_armor,
            :damage => FS3Combat.display_severity(damage)) 
        end
      end
      
      combatant.recoil = combatant.recoil + FS3Combat.weapon_stat(combatant.weapon, "recoil")
      
      message
    end
  end
end