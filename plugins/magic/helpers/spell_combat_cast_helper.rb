module AresMUSH
  module Magic

    def self.cast_shield(combatant, target, spell, rounds, result)
      shield_strength = result
      if spell.include?("Mind Shield")
        type = "psionic"
        target.update(mind_shield: shield_strength)
        target.update(mind_shield_counter: rounds)
        shield_value = target.mind_shield
      elsif spell.include?("Endure Cold")
        type = "cold"
        target.update(endure_cold: shield_strength)
        target.update(endure_cold_counter: rounds)
        shield_value = target.endure_cold
      elsif spell.include?("Endure Fire")
        type = "fire"
        target.update(endure_fire: shield_strength)
        target.update(endure_fire_counter: rounds)
        shield_value = target.endure_fire
      end

      combatant.log "Setting #{target.name}'s #{spell} to #{shield_value}"
      message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => type)]
      return message
    end

    def self.cast_combat_heal(combatant, target, spell, heal_points)
      wound = FS3Combat.worst_treatable_wound(target.associated_model)
      if wound.blank?
        message = [t('magic.no_healable_wounds', :target => target.name)]
      elsif target.death_count > 0
        message = [t('magic.cast_ko_heal', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :points => heal_points)]
        FS3Combat.heal(wound, heal_points)
      else
        message = [t('magic.cast_heal', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :points => heal_points)]
        FS3Combat.heal(wound, heal_points)
      end
      target.update(death_count: 0  )
      return message
    end

    def self.cast_weapon(combatant, target, spell, weapon)
      armor = Global.read_config("spells", spell, "armor")
      Magic.set_spell_weapon(combatant, target, weapon)
      if armor
        message = []
      else
        message = [t('magic.casts_spell', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      end
      return message
    end

    def self.cast_weapon_specials(combatant, target, spell, weapon_specials_str)
      heal_points = Global.read_config("spells", spell, "heal_points")
      lethal_mod = Global.read_config("spells", spell, "lethal_mod")
      defense_mod = Global.read_config("spells", spell, "defense_mod")
      spell_mod = Global.read_config("spells", spell, "spell_mod")
      attack_mod = Global.read_config("spells", spell, "attack_mod")
      wound = FS3Combat.worst_treatable_wound(target.associated_model)
      weapon = target.weapon.before("+")
      Magic.set_spell_weapon_effects(target, spell)
      Magic.set_spell_weapon(enactor = nil, target, weapon, [weapon_specials_str])
      if (heal_points && wound)
        message = []
      # elsif (heal_points && !wound)
      #   puts "ELSIF HEAL POINTS #{heal_points} #{wound.blank?} #{wound}"
      #   message = [t('magic.casts_spell', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      elsif lethal_mod || defense_mod || attack_mod || spell_mod
        message = []
      elsif combatant != target
        message = [t('magic.casts_spell_on_target', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
      else
        message = [t('magic.casts_spell', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      end
    end

    def self.cast_armor(combatant, target, spell, armor)
      Magic.set_spell_armor(combatant, target, armor)
      if combatant != target
        message = [t('magic.casts_spell_on_target', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
      else
        message = [t('magic.casts_spell', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      end
      return message
    end

    def self.cast_armor_specials(combatant, target, spell, armor_specials_str)
      armor_specials = armor_specials_str ? armor_specials_str.split('+') : nil
      Magic.set_spell_armor(combatant, target, target.armor, armor_specials)
      message = [t('magic.casts_spell', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      return message
    end

    def self.cast_revive(combatant, target, spell)
      target.update(is_ko: false)
      FS3Combat.emit_to_combatant target, t('magic.been_revive', :name => combatant.name)
      message = [t('magic.cast_revive', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name)]
      return message
    end

    def self.cast_auto_revive(combatant, target, spell)
      target.update(death_count: 0)
      target.update(is_ko: false)
      target.log "Auto-revive spell setting #{target.name}'s KO to #{target.is_ko}."
      Magic.delete_all_unhealed_damage(target.associated_model)
      FS3Combat.emit_to_combatant target, t('magic.been_revived', :name => combatant.name)
      if target != combatant
        message = [t('magic.cast_auto_revive_target', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name)]
      else
        message = [t('magic.cast_auto_revive', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      end
      return message
    end

    def self.cast_resurrection(combatant, target, spell)
      Custom.undead(target.associated_model)
      message = [t('magic.cast_res', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name)]
      FS3Combat.emit_to_combatant target, t('magic.been_resed', :name => combatant.name)
      return message
    end

    def self.cast_inflict_damage(combatant, target, spell, damage_inflicted, damage_desc)
      FS3Combat.inflict_damage(target.associated_model, damage_inflicted, damage_desc)
      target.update(freshly_damaged: true)
      damaged_by = target.damaged_by
      damaged_by << combatant.name
      target.update(damaged_by: damaged_by.uniq)
      message = [t('magic.cast_damage', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :damage_desc => spell.downcase)]
      return message
    end

    def self.cast_lethal_mod(combatant, target, spell, damage_type, rounds, lethal_mod, result)
      if target == combatant
        target.update(lethal_mod_counter: rounds)
        target.update(damage_lethality_mod: lethal_mod)
        message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => lethal_mod, :type => "lethality")]
      elsif damage_type == "Psionic" && target.mind_shield > 0
        shield_held = Magic.check_shield(target, combatant.name, spell, result) == "shield"
        if shield_held
           message = [t('magic.shield_held', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name)]
        else
          target.update(lethal_mod_counter: rounds)
          target.update(damage_lethality_mod: lethal_mod)
          message = [t('magic.mind_shield_failed', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        end
      else
        target.update(lethal_mod_counter: rounds)
        target.update(damage_lethality_mod: lethal_mod)
        message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => lethal_mod, :type => "lethality")]
      end
      return message
    end

    def self.cast_attack_mod(combatant, target, spell, damage_type, rounds, attack_mod, result)
      if target == combatant
        target.update(attack_mod_counter: rounds)
        target.update(spell_attack_mod: attack_mod)
        message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => attack_mod, :type => "attack")]
      elsif damage_type == "Psionic" && target.mind_shield > 0
        shield_held = Magic.check_shield(target, combatant.name, spell, result) == "shield"
        if shield_held
           message = [t('magic.shield_held', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name)]
        else
          target.update(attack_mod_counter: rounds)
          target.update(spell_attack_mod: attack_mod)
          message = [t('magic.mind_shield_failed', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        end
      else
        target.update(attack_mod_counter: rounds)
        target.update(spell_attack_mod: attack_mod)
        message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => attack_mod, :type => "attack")]
      end
      return message
    end

    def self.cast_defense_mod(combatant, target, spell, damage_type, rounds, defense_mod, result)
      if target == combatant
        target.update(defense_mod_counter: rounds)
        target.update(spell_defense_mod: defense_mod)
        message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => defense_mod, :type => "defense")]
      elsif damage_type == "Psionic" && target.mind_shield > 0
        shield_held = Magic.check_shield(target, combatant.name, spell, result) == "shield"
        if shield_held
           message = [t('magic.shield_held', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name)]
        else
          target.update(defense_mod_counter: rounds)
          target.update(spell_defense_mod: defense_mod)
          message = [t('magic.mind_shield_failed', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        end
      else
        target.update(defense_mod_counter: rounds)
        target.update(spell_defense_mod: defense_mod)
        message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => defense_mod, :type => "defense")]
      end
      return message
    end

    def self.cast_spell_mod(combatant, target, spell, damage_type, rounds, spell_mod, result)
      if target == combatant
        target.update(spell_mod_counter: rounds)
        target.update(spell_mod: spell_mod)
        message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => spell_mod, :type => "spell")]
      elsif damage_type == "Psionic" && target.mind_shield > 0
        shield_held = Magic.check_shield(target, combatant.name, spell, result) == "shield"
        if shield_held
           message = [t('magic.shield_held', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name)]
        else
          target.update(spell_mod_counter: rounds)
          target.update(spell_mod: spell_mod)
          message = [t('magic.mind_shield_failed', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        end
      else
        target.update(spell_mod_counter: rounds)
        target.update(spell_mod: spell_mod)
        message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => spell_mod, :type => "spell")]
      end
      return message
    end

    def self.cast_init_mod(combatant, target, spell, damage_type, rounds, init_mod, result)
      if target == combatant
        target.update(init_spell_mod_counter: rounds)
        target.update(init_spell_mod: init_mod)
        message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => init_mod, :type => "initiative")]
      elsif damage_type == "Psionic" && target.mind_shield > 0
        shield_held = Magic.check_shield(target, combatant.name, spell, result) == "shield"
        if shield_held
           message = [t('magic.shield_held', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name)]
        else
          target.update(init_spell_mod_counter: rounds)
          target.update(init_spell_mod: init_mod)
          message = [t('magic.mind_shield_failed', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        end
      end

      return message
    end

    def self.cast_stance(combatant, target, spell, damage_type, rounds, stance, result)
      if target == combatant
        target.update(stance: stance.titlecase)
        target.update(stance_counter: rounds)
        target.update(stance_spell: spell)
        message = [t('magic.cast_stance', :name => combatant.name, :target => target.name, :mod => "", :spell => spell, :succeeds => "%xgSUCCEEDS%xn", :stance => stance, :rounds => rounds)]
      else
        if damage_type == "Psionic" && target.mind_shield > 0
          shield_held = Magic.check_shield(target, combatant.name, spell, result) == "shield"
          if shield_held
             message = [t('magic.shield_held', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name)]
          else
            target.update(stance: stance.titlecase)
            target.update(stance_counter: rounds)
            target.update(stance_spell: spell)
            message = [t('magic.mind_shield_failed', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
          end
        else
          message = [t('magic.spell_target_resolution_msg', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        end
      end

      return message
    end

    def self.cast_combat_roll(combatant, target, spell, damage_type, result = nil)
      if target == combatant
        message = [t('magic.spell_resolution_msg', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      else
        if damage_type == "Psionic" && target.mind_shield > 0
          shield_held = Magic.check_shield(target, combatant.name, spell, result) == "shield"
          if shield_held
             message = [t('magic.shield_held', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name)]
          else
            message = [t('magic.mind_shield_failed', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
          end
        else
          message = [t('magic.spell_target_resolution_msg', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        end
      end
      return message
    end

    def self.cast_stun(combatant, target, spell, rounds, result)
      margin = Magic.determine_magic_attack_margin(combatant, target, mod = mod, result, spell)
      stopped_by_shield = margin[:stopped_by_shield] || []
      if target == combatant
        message = ["%xrYou can't stun yourself%xn"]
        return message
      end
      if (margin[:hit])
        target.update(subdued_by: combatant)
        target.update(magic_stun: true)
        target.update(magic_stun_counter: rounds.to_i)
        target.update(magic_stun_spell: spell)
        target.update(action_klass: nil)
        target.update(action_args: nil)
        if stopped_by_shield.include?("Failed")
          # message = margin[:message]
          message = [t('magic.shield_failed_stun', :name => combatant.name, :spell => spell, :shield=> "Mind Shield", :mod => "", :target => target.name, :succeeds => "%xgSUCCEEDS%xn", :rounds => rounds)]
        else
          message = [t('magic.cast_stun', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xgSUCCEEDS%xn", :rounds => rounds)]
        end
      else
        if stopped_by_shield.include?("Held")
          message = [t('magic.shield_held', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name)]
        elsif stopped_by_shield.include?("Failed")
          message = [t('magic.shield_failed_stun_resisted', :name => combatant.name, :spell => spell, :shield=> "Mind Shield", :mod => "", :target => target.name)]
        else !stopped_by_shield
          message = [t('magic.cast_failed_stun', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        end

      end
      return message
    end

    def self.cast_explosion(combatant, target, spell, result)
      messages = []
      margin = Magic.determine_magic_attack_margin(combatant, target, result = result, spell)
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
        damage_type = Global.read_config("spells", spell, "damage_type")
                shrapnel.times.each do |s|
          margin = Magic.determine_magic_attack_margin(combatant, target, result = result, spell)
          attacker_net_successes = margin[:attacker_net_successes]
          if damage_type
            messages.concat FS3Combat.resolve_attack(nil, combatant.name, target, "#{damage_type} Shrapnel", attacker_net_successes)
          else
            messages.concat FS3Combat.resolve_attack(nil, combatant.name, target, "Shrapnel", attacker_net_successes)
          end
        end
      end
      return messages
    end

    def self.cast_suppress(combatant, target, spell, result)
      composure = Global.read_config("fs3combat", "composure_skill")
      attack_roll = result
      defense_roll = target.roll_ability(composure)
      margin = attack_roll - defense_roll

      combatant.log "#{combatant.name} suppressing #{target.name} with #{spell}. atk=#{attack_roll} def=#{defense_roll} margin=#{margin}"
      if (margin >= 0)
        target.add_stress(margin + 2)
        message = [t('fs3combat.suppress_successful_msg', :name => combatant.name, :target => target.name, :weapon => "%xB#{combatant.weapon}%xn")]
      else
        message = [t('magic.casts_spell_on_target', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xrFAILS%xn")]
      end
      return message
    end

    def self.cast_attack_target(combatant, target, called_shot = nil, result)
        return [ t('fs3combat.has_no_target', :name => combatant.name) ] if !target
        margin = Magic.determine_magic_attack_margin(combatant, target, result = result, combatant.weapon)

        # Update recoil after determining the attack success but before returning out for a miss
        recoil = FS3Combat.weapon_stat(combatant.weapon, "recoil")
        combatant.update(recoil: combatant.recoil + recoil)

        return [margin[:message]] if !margin[:hit]

        weapon = combatant.weapon
        attacker_net_successes = margin[:attacker_net_successes]

        FS3Combat.resolve_attack(combatant, combatant.name, target, weapon, attacker_net_successes, called_shot)
      end

  end
end
