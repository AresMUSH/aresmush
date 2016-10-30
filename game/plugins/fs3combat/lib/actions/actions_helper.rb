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
    
    def self.determine_armor(combatant, hitloc, weapon, attack_net_success)
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
      
      margin = pen_roll + attack_net_success - protect_roll
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
    def self.determine_attack_margin(combatant, target, mod)
      attack_roll = FS3Combat.roll_attack(combatant, mod - combatant.recoil)
      defense_roll = target.roll_defense(combatant.weapon)
            
      attacker_net = attack_roll - defense_roll
      hit = false
      
      if (attack_roll <= 0)
        message = t('fs3combat.attack_missed', :name => combatant.name, :target => target.name)
      elsif (defense_roll > attack_roll)
        message = t('fs3combat.attack_dodged', :name => combatant.name, :target => target.name)
      elsif (target.stance == "Cover" && FS3Combat.stopped_by_cover?(attacker_net))
        message = t('fs3combat.attack_hits_cover', :name => combatant.name, :target => target.name)        
      else
        hit = true
      end
      
      {
        message: message,
        hit: hit,
        attacker_net_successes: attacker_net
      }
    end
      
    def self.attack_target(combatant, target, called_shot = nil, mod = 0)
      
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
          
        is_stun = FS3Combat.weapon_is_stun?(combatant.weapon)
        desc = "#{combatant.weapon} - #{hitloc}"
        mock = !combatant.combat.is_real

        combatant.inflict_damage(severity, desc, is_stun)
          
          
        message = t('fs3combat.attack_hits', 
        :name => combatant.name, 
        :target => target.name,
        :hitloc => hitloc,
        :armor => reduced_by_armor,
        :damage => FS3Combat.display_severity(damage)) 
      end
      
      
      combatant.recoil = combatant.recoil + FS3Combat.weapon_stat(combatant.weapon, "recoil")
      
      message
    end
  end
end