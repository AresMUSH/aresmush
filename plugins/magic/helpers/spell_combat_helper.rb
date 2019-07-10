module AresMUSH
  module Magic

    def self.roll_combat_spell(char, combatant, school, mod)
      accuracy_mod = FS3Combat.weapon_stat(combatant.weapon, "accuracy")
      special_mod = combatant.attack_mod
      damage_mod = combatant.total_damage_mod
      stance_mod = combatant.attack_stance_mod
      stress_mod = combatant.stress
      attack_luck_mod = (combatant.luck == "Attack") ? 3 : 0
      spell_luck_mod = (combatant.luck == "Spell") ? 3 : 0
      distraction_mod = combatant.distraction
      spell_mod = combatant.spell_mod
      if !combatant.is_npc?
        item_spell_mod = Magic.item_spell_mod(combatant.associated_model)
      else
        item_spell_mod = 0
      end


      combatant.log "Spell roll for #{combatant.name} school=#{school} mod=#{mod} spell_mod=#{spell_mod} item_spell_mod=#{item_spell_mod} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod} attack_luck=#{attack_luck_mod} spell_luck=#{spell_luck_mod} stress=#{stress_mod} special=#{special_mod} distract=#{distraction_mod}"

      mod = mod + item_spell_mod.to_i + spell_mod.to_i + accuracy_mod.to_i + damage_mod.to_i  + stance_mod.to_i  + attack_luck_mod.to_i  + spell_luck_mod.to_i - stress_mod.to_i  + special_mod.to_i - distraction_mod.to_i

      successes = combatant.roll_ability(school, mod)
      return successes
    end

    def self.cast_mind_shield(combatant, target, spell, rounds)
      shield_strength = combatant.roll_ability("Spirit")
      target.update(mind_shield: shield_strength)
      target.update(mind_shield_counter: rounds)

      combatant.log "Setting #{combatant.name}'s Mind Shield to #{shield_strength}"
      message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => "psionic")]
      return message
    end

    def self.cast_endure_fire(combatant, target, spell, rounds)
      shield_strength = combatant.roll_ability("Fire")
      target.update(target: shield_strength)
      target.update(endure_fire_counter: rounds)
      combatant.log "Setting #{target.name}'s Endure Fire to #{shield_strength}"
      message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => "fire")]
      return message
    end

    def self.cast_endure_cold(combatant, target, spell, rounds)
      shield_strength = combatant.roll_ability("Water")
      target.update(target: shield_strength)
      target.update(endure_fire_counter: rounds)
      combatant.log "Setting #{target.name}'s Endure Cold to #{shield_strength}"
      message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => "cold")]
      return message
    end

    def self.cast_combat_heal(combatant, target, spell, heal_points)
      wound = FS3Combat.worst_treatable_wound(target.associated_model)
      if (wound)
        if target.death_count > 0
          message = [t('magic.cast_ko_heal', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :points => heal_points)]
        else
          message = [t('magic.cast_heal', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :points => heal_points)]
        end
        FS3Combat.heal(wound, heal_points)
      else
         message = [t('magic.cast_heal_no_effect', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name)]
      end
      target.update(death_count: 0  )
      return message
    end

    def self.cast_weapon_specials(combatant, target, spell, weapon_specials_str)

    end

    def self.cast_armor_specials(combatant, target, spell, armor_specials_str)
      armor_specials = armor_specials_str ? armor_specials_str.split('+') : nil
      FS3Combat.set_armor(combatant, target, target.armor, armor_specials)
      message = [t('magic.casts_spell', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
    end

    def self.cast_revive(combatant, target, spell)
      target.update(is_ko: false)
      FS3Combat.emit_to_combatant target, t('magic.been_revive', :name => combatant.name)
      message = [t('magic.cast_revive', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name)]
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
      message = [t('magic.cast_damage', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :damage_desc => spell.downcase)]
      return message
    end

    def self.cast_lethal_mod(combatant, target, spell, rounds, lethal_mod)
      target.update(lethal_mod_counter: rounds)
      target.update(damage_lethality_mod: lethal_mod)
      message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod_type => lethal_mod, :type => "lethality")]
      return message
    end

    def self.cast_attack_mod(combatant, target, spell, rounds, attack_mod)
      target.update(attack_mod_counter: rounds)
      target.update(attack_mod: attack_mod)
      message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod_type => attack_mod, :type => "attack")]
      return message
    end

    def self.cast_defense_mod(combatant, target, spell, rounds, defense_mod)
      target.update(defense_mod_counter: rounds)
      target.update(defense_mod: defense_mod)
      message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod_type => defense_mod, :type => "defense")]
      return message
    end

    def self.cast_spell_mod(combatant, target, spell, rounds, spell_mod)
      target.update(spell_mod_counter: rounds)
      target.update(spell_mod: spell_mod)
      message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod_type => spell_mod, :type => "spell")]
      return message
    end

    def self.cast_stance(combatant, target, spell, rounds, stance)
      target.update(stance: stance)
      target.update(stance_counter: rounds)
      target.update(stance_spell: spell)
      message = [t('magic.cast_stance', :name => combatant.name, :target => target.name, :mod => "", :spell => spell, :succeeds => "%xgSUCCEEDS%xn", :stance => stance, :rounds => rounds)]
    end

    def self.cast_combat_roll(combatant, target, spell, effect)
      if target == combatant
        message = [t('magic.spell_resolution_msg', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      else
        if effect == "Psionic"
          message = [t('magic.shield_failed', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        else
          message = [t('magic.spell_target_resolution_msg', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        end
      end
    end

    def self.cast_stun(combatant, target, spell, rounds)
      Global.logger.debug "COMBATANT #{combatant}"
      Global.logger.debug "TARGET #{target}"
      margin = FS3Combat.determine_attack_margin(combatant, target)
      Global.logger.debug "MARGIN #{margin}"
      if (margin[:hit])
        target.update(subdued_by: combatant)
        target.update(magic_stun: true)
        target.update(magic_stun_counter: rounds.to_i)
        target.update(magic_stun_spell: spell)
        target.update(action_klass: nil)
        target.update(action_args: nil)
        message = [t('magic.cast_stun', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xgSUCCEEDS%xn", :rounds => rounds)]
      else
        message = [t('magic.casts_spell_on_target', :name => self.name, :target => target.name, :succeeds => "%xrFAILS%xn")]
      end
      return message
    end

    def self.cast_explosion(combatant, target, spell)
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
      return messages
    end


  end
end
