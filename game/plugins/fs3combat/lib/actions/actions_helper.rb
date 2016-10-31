module AresMUSH
  module FS3Combat
    def self.find_action_klass(name)
      case name
      when "attack"
        AttackAction
      when "pass"
        PassAction
      when "aim"
        AimAction
      when "reload"
        ReloadAction
      when "fullauto"
        FullautoAction
      when "treat"
        TreatAction
      else
        nil
      end
    end
    
    
    def self.reset_actions(combatant)
      # Reset aim if they've done anything other than aiming. 
      # TODO - Better way of doing this.
      # TODO - Reset action if out of ammo.
      # TODO - Reset action if target no longer exists.
      if (combatant.is_aiming && combatant.action.class != AimAction)
        Global.logger.debug "Reset aim for #{combatant.name}."
        combatant.update(is_aiming: false)
      end
      combatant.update(posed: false)
      combatant.update(recoil: 0)
    end
        
    def self.ai_action(combat, client, combatant)
      if (combatant.ammo == 0)
        FS3Combat.set_action(client, nil, combat, combatant, FS3Combat::ReloadAction, "")
        # TODO - Use suppress attack for suppress only weapon
      else
        target = combat.active_combatants.select { |t| t.team != combatant.team }.shuffle.first
        if (target)
          FS3Combat.set_action(client, nil, combat, combatant, FS3Combat::AttackAction, target.name)
        end
      end   
    end
    
    def self.set_action(client, enactor, combat, combatant, action_klass, args)
      begin
        action = action_klass.new(combatant)
        action.parse_args(args)
        error = action.error_check
        if (error)
          client.emit_failure error
          return
        end
        combat.emit "#{action.print_action}", FS3Combat.npcmaster_text(combatant.name, enactor)
      rescue Exception => err
        Global.logger.debug("Combat action error error=#{err} backtrace=#{err.backtrace[0,10]}")
        client.emit_failure t('fs3combat.invalid_action_params', :error => err)
      end
    end
    
    def self.determine_damage(combatant, hitloc, weapon, armor = 0)
      random = rand(100)
      
      lethality = FS3Combat.weapon_stat(weapon, "lethality")
      
      case FS3Combat.hitloc_severity(combatant, hitloc)
      when "Critical"
        severity = 20
      when "Vital"
        severity = 10
      else
        severity = 0
      end
      
      total = random + severity + lethality - armor
      
      if (total < 30)
        damage = "GRAZE"
      elsif (total < 70)
        damage = "FLESH"
      elsif (total <100)
        damage = "IMPAIR"
      else
        damage = "INCAP"
      end
      
      Global.logger.debug "Determined damage: loc=#{hitloc} sev=#{severity} wpn=#{weapon}" +
      " lth=#{lethality} arm=#{armor} rand=#{random} total=#{total} dmg=#{damage}"
      
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
      return 0 if !armor
      
      pen = FS3Combat.weapon_stat(weapon, "penetration")
      protect = FS3Combat.armor_stat(armor, "protection")[hitloc]
            
      # Armor doesn't cover this hit location
      return 0 if !protect

      pen_roll = FS3Skills::Api.one_shot_die_roll(pen)
      protect_roll = FS3Skills::Api.one_shot_die_roll(protect)
      
      margin = pen_roll + attacker_net_successes - protect_roll
      if (margin > 2)
        return 0
      elsif (margin < -2)
        return 100
      else
        return rand(50)
      end
    end
    
    def self.stopped_by_cover?(attacker_net_successes)
      case attacker_net_successes
      when 0, 1
        cover_chance = 50
      when 2
        cover_chance = 25
      else
        cover_chance = 0
      end
      
      return rand(100) >= cover_chance
    end
    
    # Returns { hit: true/false, attacker_net_successes: #, message: explains miss reason }
    def self.determine_attack_margin(combatant, target, mod = 0, called_shot = nil)
      weapon = combatant.weapon
      attack_roll = FS3Combat.roll_attack(combatant, mod - combatant.recoil)
      defense_roll = FS3Combat.roll_defense(target, weapon)
      
      attacker_net_successes = attack_roll - defense_roll
      hit = false
      
      if (attack_roll <= 0)
        message = t('fs3combat.attack_missed', :name => combatant.name, :target => target.name, :weapon => weapon)
      elsif (attacker_net_successes < 0)
        message = t('fs3combat.attack_dodged', :name => combatant.name, :target => target.name, :weapon => weapon)
      elsif (target.stance == "Cover" && FS3Combat.stopped_by_cover?(attacker_net_successes))
        message = t('fs3combat.attack_hits_cover', :name => combatant.name, :target => target.name, :weapon => weapon)
      elsif (called_shot && (attacker_net_successes < 1))
        message = t('fs3combat.attack_near_miss', :name => combatant.name, :target => target.name, :weapon => weapon)
      else
        hit = true
      end
      
      {
        message: message,
        hit: hit,
        attacker_net_successes: attacker_net_successes
      }
    end
      
    def self.attack_target(combatant, target, mod = 0, called_shot = nil)
      margin = FS3Combat.determine_attack_margin(combatant, target, mod, called_shot)
      return margin[:message] if !margin[:hit]
      
      weapon = combatant.weapon
      
      attacker_net_successes = margin[:attacker_net_successes]
      hitloc = FS3Combat.determine_hitloc(target, attacker_net_successes, called_shot)
      armor = FS3Combat.determine_armor(target, hitloc, weapon, attacker_net_successes)
        
      if (armor >= 100)
        return t('fs3combat.attack_stopped_by_armor', :name => combatant.name, :weapon => weapon, :target => target.name, :hitloc => hitloc) 
      end
                  
      reduced_by_armor = armor > 0 ? t('fs3combat.reduced_by_armor') : ""
          
      damage = FS3Combat.determine_damage(target, hitloc, weapon, armor)
          
      is_stun = FS3Combat.weapon_is_stun?(weapon)
      desc = "#{weapon} - #{hitloc}"

      combatant.inflict_damage(damage, desc, is_stun)
      
      recoil = FS3Combat.weapon_stat(combatant.weapon, "recoil")
      combatant.update(recoil: combatant.recoil + recoil)
      
      return t('fs3combat.attack_hits', 
            :name => combatant.name, 
            :weapon => weapon,
            :target => target.name,
            :hitloc => hitloc,
            :armor => reduced_by_armor,
            :damage => FS3Combat.display_severity(damage)) 
    end
  end
end