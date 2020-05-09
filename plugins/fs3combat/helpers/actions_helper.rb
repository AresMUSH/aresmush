module AresMUSH
  module FS3Combat
    
    def self.action_klass_map
      actions = {
        "aim" => AimAction,
        "attack" => AttackAction,
        "distract" => DistractAction,
        "escape" => EscapeAction,
        "explode" => ExplodeAction,
        "fullauto" => FullautoAction,
        "pass" => PassAction,
        "rally" => RallyAction,
        "reload" => ReloadAction,
        "treat" => TreatAction,
        "subdue" => SubdueAction,
        "suppress" => SuppressAction
      }
      if (FS3Combat.custom_actions)
        FS3Combat.custom_actions.each do |k, v|
          actions[k] = v
        end
      end
      
      actions
    end
    
    def self.find_action_klass(name)
      FS3Combat.action_klass_map[name]
    end
    
    def self.find_action_name(klass)
      if (klass.class == String)
        klass = FS3Combat.const_get(klass)
      end
      
      FS3Combat.action_klass_map.each do |name, value|
        if (value == klass)
          return name
        end
      end
      return nil
    end
    
    def self.damage_table
      Global.read_config("fs3combat", "damage_table")
    end
    
    def self.reset_for_new_turn(combatant)
      FS3Combat.custom_new_turn_reset(combatant)
      
      # Reset aim if they've done anything other than aiming. 
      if (combatant.is_aiming? && combatant.action_klass != "AresMUSH::FS3Combat::AimAction")
        combatant.log "Reset aim for #{combatant.name}."
        combatant.update(aim_target: nil)
      end
      
      if (!combatant.is_subdued?)
        combatant.update(subdued_by: nil)
      end
            
      combatant.update(luck: nil)
      combatant.update(posed: false)
      combatant.update(recoil: 0)
      FS3Combat.reset_stress(combatant)
      
      FS3Combat.check_for_ko(combatant)
      combatant.update(freshly_damaged: false)
      
      if (combatant.is_ko && combatant.is_npc?)
        FS3Combat.leave_combat(combatant.combat, combatant)
      else
        # Be sure to do this AFTER checking for KO up above.
        combatant.update(damaged_by: [])
      end
    end
    
    def self.reset_stress(combatant)
      return if combatant.stress == 0

      composure = Global.read_config("fs3combat", "composure_skill")
      roll = combatant.roll_ability(composure)
      new_stress = [0, combatant.stress - roll - 1].max
      
      combatant.log "#{combatant.name} resetting stress.  roll=#{roll} old_stress=#{combatant.stress} new_stress=#{new_stress}."
      combatant.update(stress: new_stress)
    end
    
    def self.check_for_ko(combatant)
      return if (!combatant.freshly_damaged || combatant.is_ko || combatant.total_damage_mod > -1.0)

      combatant.log "Checking for KO: #{combatant.name} damaged=#{combatant.freshly_damaged} ko=#{combatant.is_ko} mod=#{combatant.total_damage_mod}"
      
      if (combatant.is_npc? && (combatant.total_damage_mod <= -7))
        combatant.log "#{combatant.name} auto-KO'd."
        roll = 0
      else
        roll = FS3Combat.make_ko_roll(combatant)
      end
      
      if (roll <= 0)
        combatant.update(is_ko: true)
        combatant.update(action_klass: nil)
        combatant.update(action_args: nil)
        damaged_by = combatant.damaged_by.join(", ")
        FS3Combat.emit_to_combat combatant.combat, t('fs3combat.is_koed', :name => combatant.name, :damaged_by => damaged_by), nil, true
      end
    end
      
    def self.check_for_unko(combatant)
      return if !combatant.is_ko
      roll = FS3Combat.make_ko_roll(combatant, 3)
      
      if (roll > 0)
        combatant.update(is_ko: false)
        FS3Combat.emit_to_combat combatant.combat, t('fs3combat.is_no_longer_koed', :name => combatant.name), nil, true
      end
    end
    
    def self.make_ko_roll(combatant, ko_mod = 0)
      pc_mod = combatant.is_npc? ? 0 : Global.read_config("fs3combat", "pc_knockout_bonus")

      composure = Global.read_config("fs3combat", "composure_skill")
      
      if (combatant.is_in_vehicle?)
        vehicle = combatant.vehicle
        vehicle_mod = FS3Combat.vehicle_stat(vehicle.vehicle_type, "toughness").to_i
      else
        vehicle_mod = 0
      end
      
      damage_mod = combatant.total_damage_mod
      
      mod = damage_mod + damage_mod + pc_mod + vehicle_mod + ko_mod
      roll = combatant.roll_ability(composure, mod)
      
      combatant.log "#{combatant.name} checking KO. roll=#{roll} composure=#{composure} damage=#{damage_mod} vehicle=#{vehicle_mod} pc=#{pc_mod} mod=#{ko_mod}"
      
      roll
    end
        
    def self.ai_action(combat, combatant, enactor = nil)
      if (combatant.is_subdued?)
        FS3Combat.set_action(enactor, combat, combatant, FS3Combat::EscapeAction, "")
      elsif (!FS3Combat.check_ammo(combatant, 1))
        FS3Combat.set_action(enactor, combat, combatant, FS3Combat::ReloadAction, "")
      else
        target = FS3Combat.find_ai_target(combat, combatant)
        if (target)
          weapon_type = FS3Combat.weapon_stat(combatant.weapon, "weapon_type")
          case weapon_type
          when "Explosive"
            action_klass = FS3Combat::ExplodeAction
          when "Suppressive"
            action_klass = FS3Combat::SuppressAction
          else
            action_klass = FS3Combat::AttackAction
          end
          FS3Combat.set_action(enactor, combat, combatant, action_klass, target.name)
        else
          FS3Combat.set_action(enactor, combat, combatant, FS3Combat::PassAction, "")
        end
      end   
    end
    
    def self.find_ai_target(combat, attacker)
      attacking_team = attacker.team
      default_targets = [ 1, 2, 3, 4, 5, 6, 7, 8, 9]
      default_targets.delete(attacking_team)
      team_targets = combat.team_targets[attacking_team.to_s] || default_targets
      
      possible_targets = combat.active_combatants.select { |t| team_targets.include?(t.team) && 
                                                               t.stance != "Hidden"}
      possible_targets.shuffle.first
    end
    
    def self.set_action(enactor, combat, combatant, action_klass, args)
      action = action_klass.new(combatant, args)
      error = action.prepare
      if (error)
        return error
      end
      combatant.update(action_klass: action_klass)
      combatant.update(action_args: args)
      FS3Combat.emit_to_combat combat, "#{action.print_action}", FS3Combat.npcmaster_text(combatant.name, enactor)
    end

    def self.determine_damage(combatant, hitloc, weapon, mod = 0, crew_hit = false)
      random = rand(100)
      
      lethality = FS3Combat.weapon_stat(weapon, "lethality")
                  
      case FS3Combat.hitloc_severity(combatant, hitloc, crew_hit)
      when "Critical"
        severity = 30
      when "Vital"
        severity = 0
      else
        severity = -30
      end
      
      npc = combatant.is_npc? ? combatant.npc.wound_modifier : 0
      npc_mod = combatant.damage_lethality_mod + npc
      
      total = random + severity + lethality + mod + npc_mod
      
      if (total < FS3Combat.damage_table["GRAZE"])
        damage = "GRAZE"
      elsif (total < FS3Combat.damage_table["FLESH"])
        damage = "FLESH"
      elsif (total < FS3Combat.damage_table["IMPAIR"])
        damage = "IMPAIR"
      else
        damage = "INCAP"
      end
      
      combatant.log "Determined damage: loc=#{hitloc} sev=#{severity} wpn=#{weapon}" +
      " lth=#{lethality} npc=#{npc_mod} mod=#{mod} rand=#{random} total=#{total} dmg=#{damage}"
      
      damage
    end
    
    def self.determine_armor(combatant, hitloc, weapon, attacker_net_successes)
      vehicle = combatant.vehicle
      if (vehicle)
        armor = vehicle.armor
      else
        armor = combatant.armor
      end
      
      # Not wearing armor at all.
      return 0 if armor.blank?
      
      pen = FS3Combat.weapon_stat(weapon, "penetration")
      protect = FS3Combat.armor_stat(armor, "protection")[hitloc]
            
      # Armor doesn't cover this hit location
      return 0 if !protect
      random_die = rand(8) + 1
      result = random_die + attacker_net_successes + pen - protect
            
      if (result >= 8) # 8-9
        armor_reduction = 0
      elsif (result >= 6) # 6-7
        armor_reduction = rand(25)
      elsif (result >= 4) # 4-5
        armor_reduction = rand(25) + 25
      elsif (result >= 2) # 2-3
        armor_reduction = rand(50) + 50
      else # 0-1
        armor_reduction = 100
      end
      
     combatant.log "Determined armor: loc=#{hitloc} weapon=#{weapon} net=#{attacker_net_successes}" +
      " pen=#{pen} protect=#{protect} random=#{random_die} result=#{result} reduction=#{armor_reduction}"
      
      armor_reduction
    end
    
    def self.stopped_by_cover?(attacker_net_successes, combatant)
      case attacker_net_successes
      when 0, 1
        cover_chance = 50
      when 2
        cover_chance = 25
      else
        cover_chance = 0
      end
      
      roll = rand(100) 
      result = roll < cover_chance
            
      combatant.log "Determined cover: net=#{attacker_net_successes}" +
            " chance=#{cover_chance} roll=#{roll} result=#{result}"
      
      result
    end
    
    def self.hit_mount?(attacker, defender, attacker_net_successes, mount_hit)
      return false if !defender.mount_type

      # Bigger chance of hitting mount if you're on the ground.  Less chance if you rolled well - unless
      # of course you were aiming for the mount deliberately.
      if (attacker_net_successes > 0 && mount_hit)
        hit_chance = 90
      elsif (attacker_net_successes > 2)
        hit_chance = 0
      elsif (attacker.mount_type)
        hit_chance = 20
      else
        hit_chance = 40
      end
      
      roll = rand(100) 
      result = roll < hit_chance
            
      attacker.log "Determined mount hit: chance=#{hit_chance} roll=#{roll} result=#{result}"
      
      result
    end
    
    def self.resolve_mount_ko(target)
      toughness = FS3Combat.mount_stat(target.mount_type, 'toughness').to_i
      roll = FS3Skills.one_shot_die_roll(toughness)[:successes]
      
      target.log "Determined mount damage: tough=#{toughness} roll=#{roll}"
      
      roll <= 0
    end
    
    # Returns { hit: true/false, attacker_net_successes: #, message: explains miss reason }
    def self.determine_attack_margin(combatant, target, mod = 0, called_shot = nil, mount_hit = false)
      weapon = combatant.weapon
      attack_roll = FS3Combat.roll_attack(combatant, target, mod - combatant.recoil)
      defense_roll = FS3Combat.roll_defense(target, weapon)
      
      attacker_net_successes = attack_roll - defense_roll
      stopped_by_cover = target.stance == "Cover" ? FS3Combat.stopped_by_cover?(attacker_net_successes, combatant) : false
      hit = false
      weapon_type = FS3Combat.weapon_stat(combatant.weapon, "weapon_type")
      hit_mount = FS3Combat.hit_mount?(combatant, target, attacker_net_successes, mount_hit)
      
      if (attack_roll <= 0)
        message = t('fs3combat.attack_missed', :name => combatant.name, :target => target.name, :weapon => weapon)
      elsif (called_shot && (attacker_net_successes > 0) && (attacker_net_successes < 2))
        message = t('fs3combat.attack_near_miss', :name => combatant.name, :target => target.name, :weapon => weapon)
      elsif (hit_mount)
        mount_ko = FS3Combat.resolve_mount_ko(target)
        if (mount_ko)
          
          mount_effect = t('fs3combat.mount_ko')
          target.inflict_damage('IMPAIR', 'Fall Damage', true, false)
          target.update(mount_type: nil)
        else
          mount_effect =  t('fs3combat.mount_injured')
        end

        message = t('fs3combat.attack_hits_mount', :name => combatant.name, :target => target.name, :weapon => weapon, :effect => mount_effect)
      elsif (stopped_by_cover)
        message = t('fs3combat.attack_hits_cover', :name => combatant.name, :target => target.name, :weapon => weapon)
      elsif (attacker_net_successes < 0)
        # Only can evade when being attacked by melee or when in a vehicle.
        if (weapon_type == 'Melee' || target.is_in_vehicle?)
          if (attacker_net_successes < -2)
            message = t('fs3combat.attack_dodged_easily', :name => combatant.name, :target => target.name, :weapon => weapon)
          else
            message = t('fs3combat.attack_dodged', :name => combatant.name, :target => target.name, :weapon => weapon)
          end
        else
            message = t('fs3combat.attack_near_miss', :name => combatant.name, :target => target.name, :weapon => weapon)
        end
      else
        hit = true
      end
      
      
      combatant.log "Attack Margin: mod=#{mod} called=#{called_shot} " +
      " attack=#{attack_roll} defense=#{defense_roll} hit=#{hit} cover=#{stopped_by_cover} result=#{message}"
      
      
      {
        message: message,
        hit: hit,
        attacker_net_successes: attacker_net_successes
      }
    end
      
    def self.attack_target(combatant, target, mod = 0, called_shot = nil, crew_hit = false, mount_hit = false)
      return [ t('fs3combat.has_no_target', :name => combatant.name) ] if !target
      
      # If targeting a passenger, adjust target to the pilot instead.  Unless of course there isn't one.
      if (target.riding_in && target.riding_in.pilot)
        target = target.riding_in.pilot
      end
      
      margin = FS3Combat.determine_attack_margin(combatant, target, mod, called_shot, mount_hit)

      # Update recoil after determining the attack success but before returning out for a miss
      recoil = FS3Combat.weapon_stat(combatant.weapon, "recoil")
      combatant.update(recoil: combatant.recoil + recoil)

      return [margin[:message]] if !margin[:hit]
    
      weapon = combatant.weapon
      
      attacker_net_successes = margin[:attacker_net_successes]
            
      FS3Combat.resolve_attack(combatant, combatant.name, target, weapon, attacker_net_successes, called_shot, crew_hit)
    end
    
    # Attacker may be nil for automated attacks like shrapnel
    def self.resolve_attack(attacker, attack_name, target, weapon, attacker_net_successes = 0, called_shot = nil, crew_hit = false)
      hitloc = FS3Combat.determine_hitloc(target, attacker_net_successes, called_shot, crew_hit)
      armor = FS3Combat.determine_armor(target, hitloc, weapon, attacker_net_successes)
        
      
      if (armor >= 100)
        message = t('fs3combat.attack_stopped_by_armor', :name => attack_name, :weapon => weapon, :target => target.name, :hitloc => hitloc) 
        return [message]
      end
                  
      reduced_by_armor = armor > 0 ? t('fs3combat.reduced_by_armor') : ""

      attack_luck_mod = (attacker && attacker.luck == "Attack") ? 30 : 0
      
      defense_luck_mod = target.luck == "Defense" ? 30 : 0 
          
      hit_mod = [(attacker_net_successes - 1) * 5, 0].max
      hit_mod = [25, hit_mod].min
      
      melee_damage_mod = 0
      weapon_type = FS3Combat.weapon_stat(weapon, "weapon_type")
      
      if (!weapon_type)
        return [ t('fs3combat.attack_with_missing_weapon', :name => weapon) ]
      end
      
      weapon_type = weapon_type.titlecase
      if (weapon_type == "Melee")
        strength_roll = FS3Combat.roll_strength(attacker)
        melee_damage_mod = [(strength_roll - 1) * 5, 0].max
      end
      
      total_damage_mod = hit_mod + melee_damage_mod + attack_luck_mod - defense_luck_mod - armor
      target.log "Damage modifiers: attack_luck=#{attack_luck_mod} hit=#{hit_mod} melee=#{melee_damage_mod} defense_luck=#{defense_luck_mod} armor=#{armor} total=#{total_damage_mod}"
      
      
      damage = FS3Combat.determine_damage(target, hitloc, weapon, total_damage_mod, crew_hit)
          
      is_stun = FS3Combat.weapon_is_stun?(weapon)
      desc = "#{weapon} - #{hitloc}"

      target.inflict_damage(damage, desc, is_stun, crew_hit)

      if (damage != "GRAZE")
        target.update(freshly_damaged: true)
        
        damaged_by = target.damaged_by
        damaged_by << attack_name
        target.update(damaged_by: damaged_by.uniq)
      end
            
      target.add_stress(1)
      
      messages = []
      
      weapon_type = FS3Combat.weapon_stat(weapon, 'weapon_type')
      if (weapon_type == "Explosive")
        weapon_name = t('fs3combat.concussion_from', :weapon => weapon)
      else
        weapon_name = weapon
      end
      
      FS3Combat.award_hit_achievement(attacker, damage, weapon_type)
      
      messages << t('fs3combat.attack_hits', 
                    :name => attack_name, 
                    :weapon => weapon_name,
                    :target => target.name,
                    :hitloc => hitloc,
                    :armor => reduced_by_armor,
                    :damage => FS3Combat.display_severity(damage)) 

      messages.concat FS3Combat.resolve_possible_crew_hit(target, hitloc, damage)
      messages
    end
    
    def self.award_hit_achievement(attacker, damage, weapon_type)
      return if !attacker
      return if attacker.is_npc?
      return if !attacker.combat.is_real
      return if damage == 'GRAZE'
      
      [ "explosive", "melee", "ranged", ].each do |hit|
        if (weapon_type.downcase == hit)
          Achievements.award_achievement(attacker.associated_model, "fs3_#{hit}_hit")  
        end
      end
      if (damage == "INCAP")
        Achievements.award_achievement(attacker.associated_model, "fs3_hard_hitter")
      end
    end
    
    def self.resolve_possible_crew_hit(target, hitloc, damage)
      messages = []
      return [] if (!target.is_in_vehicle?)
      vehicle = target.vehicle
      crew_hitlocs = FS3Combat.hitloc_chart(target)["crew_areas"]
      
      return [] if (!crew_hitlocs.include?(hitloc))

      people = vehicle.passengers.to_a
      if (vehicle.pilot)
        people << vehicle.pilot
      end
      
      people.each do |p|
        case damage
        when "GRAZE"
          shrapnel = 0
        when "FLESH"
          shrapnel = rand(1)
        when "IMPAIR"
          shrapnel = rand(3)
        when "INCAP"
          shrapnel = rand(5)
        end
                
        target.log "Crew area hit. #{p.name} shrapnel=#{shrapnel}"
        shrapnel.times.each do |s|
          messages.concat FS3Combat.resolve_attack(nil, t('fs3combat.crew_hit'), p, "Shrapnel", 0, nil, true)
        end
      end
      
      messages
    end
    
    def self.resolve_explosion(combatant, target)
      messages = []
      margin = FS3Combat.determine_attack_margin(combatant, target)
      if (margin[:hit])
        attacker_net_successes = margin[:attacker_net_successes]
        messages.concat FS3Combat.resolve_attack(combatant, combatant.name, target, combatant.weapon, attacker_net_successes)
        max_shrapnel = [ 5, attacker_net_successes + 2 ].min
      else
        messages << margin[:message]
        max_shrapnel = 2
      end
      
      if (FS3Combat.weapon_stat(combatant.weapon, "has_shrapnel"))      
        shrapnel = rand(max_shrapnel)
        shrapnel.times.each do |s|
          messages.concat FS3Combat.resolve_attack(nil, combatant.name, target, "Shrapnel")
        end
      end
      messages
    end
  end
end