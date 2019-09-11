module AresMUSH
  module Magic

    def self.roll_combat_spell(char, combatant, school, mod = 0)
      accuracy_mod = FS3Combat.weapon_stat(combatant.weapon, "accuracy")
      special_mod = combatant.attack_mod
      damage_mod = combatant.total_damage_mod
      stance_mod = combatant.attack_stance_mod
      stress_mod = combatant.stress
      attack_luck_mod = (combatant.luck == "Attack") ? 3 : 0
      spell_luck_mod = (combatant.luck == "Spell") ? 3 : 0
      distraction_mod = combatant.distraction
      spell_mod = combatant.spell_mod ? combatant.spell_mod : 0
      if !combatant.is_npc?
        item_spell_mod = Magic.item_spell_mod(combatant.associated_model)
      else
        item_spell_mod = 0
      end

      combatant.log "Spell roll for #{combatant.name} school=#{school} mod=#{mod} spell_mod=#{spell_mod} item_spell_mod=#{item_spell_mod} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod} attack_luck=#{attack_luck_mod} spell_luck=#{spell_luck_mod} stress=#{stress_mod} special=#{special_mod} distract=#{distraction_mod}"

      mod = mod.to_i + item_spell_mod.to_i + spell_mod.to_i + accuracy_mod.to_i + damage_mod.to_i  + stance_mod.to_i  + attack_luck_mod.to_i  + spell_luck_mod.to_i - stress_mod.to_i  + special_mod.to_i - distraction_mod.to_i

      successes = combatant.roll_ability(school, mod)
      return successes
    end

    def self.roll_combat_spell_success(caster_combatant, spell)
      #spell mods live in roll_combat_spell
      if caster_combatant.npc
        school = Global.read_config("spells", spell, "school")
        mod = 0
      elsif Magic.knows_spell?(caster_combatant, spell)
        school = Global.read_config("spells", spell, "school")
        mod = 0
      else
        school = "Magic"
        mod = FS3Skills.ability_rating(caster_combatant.associated_model, "Magic") * 2
      end

      die_result = Magic.roll_combat_spell(caster_combatant, caster_combatant, school, mod)
      succeeds = Magic.spell_success(spell, die_result)
    end

    def self.set_spell_weapon_effects(combatant, spell)
      rounds = Global.read_config("spells", spell, "rounds")
      special = Global.read_config("spells", spell, "weapon_specials")
      weapon = combatant.weapon.before("+")
      weapon_specials = combatant.spell_weapon_effects

      if combatant.spell_weapon_effects.has_key?(weapon)
        old_weapon_specials = weapon_specials[weapon]
        weapon_specials[weapon] = old_weapon_specials.merge!( special => rounds)
      else
        weapon_specials[weapon] = {special => rounds}
      end
      combatant.update(spell_weapon_effects: weapon_specials)
    end

    def self.spell_armor_effects(combatant, spell)
      rounds = Global.read_config("spells", spell, "rounds")
      special = Global.read_config("spells", spell, "armor_specials")
      weapon = combatant.armor.before("+")
      weapon_specials = combatant.spell_armor_effects

      if combatant.spell_armor_effects.has_key?(armor)
        old_armor_specials = armor_specials[armor]
        armor_specials[armor] = old_armor_specials.merge!( special => rounds)
      else
        armor_specials[armor] = {special => rounds}
      end
      combatant.update(spell_armor_effects:armor_specials)
    end

    def self.cast_mind_shield(combatant, target, spell, rounds)
      shield_strength = combatant.roll_ability("Spirit")
      target.update(mind_shield: shield_strength)
      target.update(mind_shield_counter: rounds)
      combatant.log "Setting #{combatant.name}'s Mind Shield to #{target.mind_shield}"
      message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => "psionic")]
      return message
    end

    def self.cast_endure_fire(combatant, target, spell, rounds)
      shield_strength = combatant.roll_ability("Fire")
      target.update(endure_fire: shield_strength)
      target.update(endure_fire_counter: rounds)
      combatant.log "Setting #{target.name}'s Endure Fire to #{target.endure_fire}"
      message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => "fire")]
      return message
    end

    def self.cast_endure_cold(combatant, target, spell, rounds)
      shield_strength = combatant.roll_ability("Water")
      target.update(endure_cold: shield_strength)
      target.update(endure_cold_counter: rounds)
      combatant.log "Setting #{target.name}'s Endure Cold to #{target.endure_cold}"
      message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => "cold")]
      return message
    end

    def self.cast_combat_heal(combatant, target, spell, heal_points)
      wound = FS3Combat.worst_treatable_wound(target.associated_model)
      if target.death_count > 0
        message = [t('magic.cast_ko_heal', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :points => heal_points)]
      else
        message = [t('magic.cast_heal', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :points => heal_points)]
      end
      FS3Combat.heal(wound, heal_points)
      target.update(death_count: 0  )
      return message
    end

    def self.cast_weapon(combatant, target, spell, weapon)
      armor = Global.read_config("spells", spell, "armor")
      FS3Combat.set_weapon(combatant, target, weapon)
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
      Magic.set_spell_weapon_effects(target, spell)
      attack_mod = Global.read_config("spells", spell, "attack_mod")

      weapon = combatant.weapon.before("+")
      FS3Combat.set_weapon(enactor = nil, target, weapon, [weapon_specials_str])
      if heal_points
        message = []
      elsif lethal_mod || defense_mod || attack_mod || spell_mod
        message = []
      else
        message = [t('magic.casts_spell', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      end
    end

    def self.cast_armor(combatant, target, spell, armor)
      FS3Combat.set_armor(combatant, target, armor)
      message = [t('magic.casts_spell', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      return message
    end

    def self.cast_armor_specials(combatant, target, spell, armor_specials_str)
      armor_specials = armor_specials_str ? armor_specials_str.split('+') : nil
      FS3Combat.set_armor(combatant, target, target.armor, armor_specials)
      message = [t('magic.casts_spell', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      return message
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
      damaged_by = target.damaged_by
      damaged_by << combatant.name
      target.update(damaged_by: damaged_by.uniq)
      message = [t('magic.cast_damage', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :damage_desc => spell.downcase)]
      return message
    end

    def self.cast_lethal_mod(combatant, target, spell, rounds, lethal_mod)
      target.update(lethal_mod_counter: rounds)
      target.update(damage_lethality_mod: lethal_mod)
      message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => lethal_mod, :type => "lethality")]
      return message
    end

    def self.cast_attack_mod(combatant, target, spell, rounds, attack_mod)
      target.update(attack_mod_counter: rounds)
      target.update(attack_mod: attack_mod)
      message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => attack_mod, :type => "attack")]
      return message
    end

    def self.cast_defense_mod(combatant, target, spell, rounds, defense_mod)
      target.update(defense_mod_counter: rounds)
      target.update(defense_mod: defense_mod)
      message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => defense_mod, :type => "defense")]
      return message
    end

    def self.cast_spell_mod(combatant, target, spell, rounds, spell_mod)
      target.update(spell_mod_counter: rounds)
      target.update(spell_mod: spell_mod)
      message = [t('magic.cast_mod', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :mod => spell_mod, :type => "spell")]
      return message
    end

    def self.cast_stance(combatant, target, spell, rounds, stance)
      target.update(stance: stance)
      target.update(stance_counter: rounds)
      target.update(stance_spell: spell)
      message = [t('magic.cast_stance', :name => combatant.name, :target => target.name, :mod => "", :spell => spell, :succeeds => "%xgSUCCEEDS%xn", :stance => stance, :rounds => rounds)]
      return message
    end

    def self.cast_combat_roll(combatant, target, spell, effect)
      if target == combatant
        message = [t('magic.spell_resolution_msg', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
      else
        if effect == "Psionic" && target.mind_shield > 0
          shield_held = Magic.roll_shield(target, combatant, spell) == "shield"
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

    def self.cast_stun(combatant, target, spell, rounds, mod)
      margin = FS3Combat.determine_attack_margin(combatant, target, mod = mod)
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
        message = [t('magic.cast_stun', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xgSUCCEEDS%xn", :rounds => rounds)]
      else
        message = [t('magic.casts_spell_on_target', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xrFAILS%xn")]
      end
      return message
    end

    def self.cast_explosion(combatant, target, spell, mod)
      messages = []
      margin = FS3Combat.determine_attack_margin(combatant, target, mod = mod)
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

    def self.cast_suppress(combatant, target, spell, mod)
      composure = Global.read_config("fs3combat", "composure_skill")
      attack_roll = FS3Combat.roll_attack(combatant, target, mod = mod)
      defense_roll = target.roll_ability(composure)
      margin = attack_roll - defense_roll

      combatant.log "#{combatant.name} suppressing #{target.name} with #{spell}.  atk=#{attack_roll} atk_mod=#{mod} def=#{defense_roll} "
      if (margin >= 0)
        target.add_stress(margin + 2)
        message = [t('fs3combat.suppress_successful_msg', :name => combatant.name, :target => target.name, :weapon => "%xB#{combatant.weapon}%xn")]
      else
        message = [t('magic.casts_spell_on_target', :name => combatant.name, :spell => spell, :mod => "", :target => target.name, :succeeds => "%xrFAILS%xn")]
      end
      return message
    end


  end
end
