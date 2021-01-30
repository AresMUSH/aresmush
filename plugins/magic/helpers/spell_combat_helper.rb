module AresMUSH
  module Magic

    def self.roll_combat_spell(char, combatant, school, cast_mod = 0, level_mod)
      accuracy_mod = FS3Combat.weapon_stat(combatant.weapon, "accuracy")
      attack_mod = combatant.attack_mod
      spell_attack_mod = combatant.spell_attack_mod
      damage_mod = combatant.total_damage_mod
      stance_mod = combatant.attack_stance_mod
      stress_mod = combatant.stress
      attack_luck_mod = (combatant.luck == "Attack") ? 3 : 0
      spell_luck_mod = (combatant.luck == "Spell") ? 3 : 0
      distraction_mod = combatant.distraction
      gm_spell_mod = combatant.gm_spell_mod
      spell_mod = combatant.spell_mod ? combatant.spell_mod : 0
      if !combatant.is_npc?
        item_spell_mod = Magic.item_spell_mod(combatant.associated_model)
        item_attack_mod = Magic.item_attack_mod(combatant.associated_model)
      else
        item_spell_mod = 0
        item_attack_mod = 0
      end
      total_mod = cast_mod + item_spell_mod.to_i + item_attack_mod.to_i + gm_spell_mod.to_i + spell_mod.to_i + accuracy_mod.to_i + damage_mod.to_i  + stance_mod.to_i  + attack_luck_mod.to_i  + spell_luck_mod.to_i - stress_mod.to_i  + spell_attack_mod.to_i + attack_mod.to_i - distraction_mod.to_i + level_mod.to_i

      combatant.log "SPELL ROLL for #{combatant.name} school=#{school} level_mod=#{level_mod} off-school_cast_mod=#{cast_mod} spell_mod=#{spell_mod} spell_luck=#{spell_luck_mod} gm_spell_mod=#{gm_spell_mod} item_spell_mod=#{item_spell_mod} attack=#{attack_mod} spell_attack=#{spell_attack_mod} item_attack_mod=#{item_attack_mod} attack_luck=#{attack_luck_mod} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod}   stress=#{stress_mod}  distract=#{distraction_mod} total_mod=#{total_mod}"

      successes = combatant.roll_ability(school, total_mod)
      return successes
    end

    def self.roll_combat_spell_success(caster_combatant, spell)
      #spell mods live in roll_combat_spell
      cast_mod = 0
      level = Global.read_config("spells", spell, "level")

      if level == 1
        level_mod = 0
      else
        level_mod = 0 - level
      end

      if caster_combatant.npc
        skill = Global.read_config("spells", spell, "school")
      else
        caster = caster_combatant.associated_model
        schools = [caster.group("Minor School"), caster.group("Major School")]
        school = Global.read_config("spells", spell, "school")
        if schools.include?(school)
          skill = school
        else
          skill = "Magic"
          cast_mod = FS3Skills.ability_rating(caster, "Magic") * 2
        end
      end

      die_result = Magic.roll_combat_spell(caster_combatant, caster_combatant, skill, cast_mod = cast_mod, level_mod = level_mod)
      succeeds = Magic.spell_success(spell, die_result)
      return {:succeeds => succeeds, :result => die_result}
    end

    def self.determine_magic_attack_margin(combatant, target, called_shot = nil, result, spell)
      weapon = combatant.weapon
      attack_roll = result
      defense_roll = FS3Combat.roll_defense(target, weapon)

      attacker_net_successes = attack_roll - defense_roll
      stopped_by_cover = target.stance == "Cover" ? FS3Combat.stopped_by_cover?(attacker_net_successes, combatant) : false
      hit = false

      stopped_by_shield = Magic.stopped_by_shield?(spell, target, combatant, attack_roll)
      weapon_type = FS3Combat.weapon_stat(combatant.weapon, "weapon_type")

      if (attack_roll <= 0)
        message = t('fs3combat.attack_missed', :name => combatant.name, :target => target.name, :weapon => weapon)
      elsif (called_shot && (attacker_net_successes > 0) && (attacker_net_successes < 2))
        message = t('fs3combat.attack_near_miss', :name => combatant.name, :target => target.name, :weapon => weapon)
      elsif (stopped_by_cover)
        message = t('fs3combat.attack_hits_cover', :name => combatant.name, :target => target.name, :weapon => weapon)
      elsif stopped_by_shield == "Endure Fire Held"
        message = t('custom.shield_held', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Endure Fire", :target => target.name)
      elsif stopped_by_shield == "Endure Cold Held"
        message = t('custom.shield_held', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Endure Cold", :target => target.name)
      elsif stopped_by_shield == "Mind Shield Held"
        message = t('custom.shield_held', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Mind Shield", :target => target.name)
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
        if stopped_by_shield == "Mind Shield Failed"
          message = [t('magic.mind_shield_failed', :name => combatant.name, :spell => spell, :mod => "", :shield => "Mind Shield", :target => target.name, :succeeds => "%xgSUCCEEDS%xn")]
        end
        hit = true
      end

      combatant.log "ATTACK MARGIN: called=#{called_shot} " +
      "attack=#{attack_roll} defense=#{defense_roll} hit=#{hit} cover=#{stopped_by_cover} shield=#{stopped_by_shield} result=#{message}"

      {
        message: message,
        hit: hit,
        attacker_net_successes: attacker_net_successes,
        stopped_by_shield: stopped_by_shield
      }
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

    # def self.cast_endure_fire(combatant, target, spell, rounds, result)
    #   shield_strength = result
    #   target.update(endure_fire: shield_strength)
    #   target.update(endure_fire_counter: rounds)
    #   combatant.log "Setting #{target.name}'s Endure Fire to #{target.endure_fire}"
    #   message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => "fire")]
    #   return message
    # end
    #
    # def self.cast_endure_cold(combatant, target, spell, rounds, result)
    #   shield_strength = result
    #   target.update(endure_cold: shield_strength)
    #   target.update(endure_cold_counter: rounds)
    #   combatant.log "Setting #{target.name}'s Endure Cold to #{target.endure_cold}"
    #   message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => "cold")]
    #   return message
    # end

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
      wound = FS3Combat.worst_treatable_wound(target.associated_model)
      weapon = combatant.weapon.before("+")
      FS3Combat.set_weapon(enactor = nil, target, weapon, [weapon_specials_str])
      if (heal_points && wound)
        message = []
      # elsif (heal_points && !wound)
      #   puts "ELSIF HEAL POINTS #{heal_points} #{wound.blank?} #{wound}"
      #   message = [t('magic.casts_spell', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn")]
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
