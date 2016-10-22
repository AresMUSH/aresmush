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
      if (c.is_aiming && c.action.class != AimAction)
        Global.logger.debug "Reset aim for #{c.name}."
        c.is_aiming = false
      end
      c.update(posed: false)
      c.update(recoil: 0)
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
      end
      
      combatant.recoil = combatant.recoil + FS3Combat.weapon_stat(combatant.weapon, "recoil")
      
      message
    end
        
    def self.ai_action(combat, client, combatant)
      if (combatant.ammo == 0)
        FS3Combat.set_action(client, nil, self, combatant, FS3Combat::ReloadAction, "")
        # TODO - Use suppress attack for suppress only weapon
      else
        target = active_combatants.select { |t| t.team != combatant.team }.shuffle.first
        if (target)
          FS3Combat.set_action(client, nil, self, combatant, FS3Combat::AttackAction, target.name)
        end
      end   
    end
  end
end