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
      elsif stopped_by_shield
        message = stopped_by_shield[:msg]
        hit = stopped_by_shield[:hit]
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

    def self.warn_if_magic_gear(enactor, gear)
      if Magic.is_magic_armor(gear) || Magic.is_magic_weapon(gear)
        FS3Combat.emit_to_combat(enactor.combat, t('magic.cast_to_use', :name => gear))
      end
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

    def self.set_magic_weapon_specials(enactor, combatant, weapon)
      # Set weapon specials gained from equipped magical items
      specials = Magic.set_magic_item_weapon_specials(combatant, specials)

      # Set weapon specials gained from spells
      if specials && combatant.spell_weapon_effects[weapon]
        spell_specials = combatant.spell_weapon_effects[weapon].keys
        specials = specials.concat spell_specials
      elsif combatant.spell_weapon_effects[weapon]
        specials = combatant.spell_weapon_effects[weapon].keys
      end
      return specials
    end

    def self.set_spell_weapon(enactor, combatant, weapon, specials = nil)

      specials = Magic.set_magic_weapon_specials(enactor, combatant, weapon)

      max_ammo = weapon ? FS3Combat.weapon_stat(weapon, "ammo") : 0
      weapon = weapon ? weapon.titlecase : "Unarmed"
      prior_ammo = combatant.prior_ammo || {}

      current_ammo = max_ammo
      if (weapon && prior_ammo[weapon] != nil)
        current_ammo = prior_ammo[weapon]
      end

      if (combatant.weapon_name)
        prior_ammo[combatant.weapon_name] = combatant.ammo
        combatant.update(prior_ammo: prior_ammo)
      end

      combatant.update(weapon_name: weapon)
      combatant.update(weapon_specials: specials ? specials.map { |s| s.titlecase }.uniq : [])
      combatant.update(ammo: current_ammo)
      combatant.update(max_ammo: max_ammo)
      #Does not reset action, unlike vanilla FS3 set_weapon
      message = t('fs3combat.weapon_changed', :name => combatant.name,
        :weapon => combatant.weapon)
      FS3Combat.emit_to_combat combatant.combat, message, FS3Combat.npcmaster_text(combatant.name, enactor)
    end

    def self.set_spell_armor(enactor, combatant, armor, specials = nil)

      specials = Magic.set_magic_item_armor_specials(combatant, specials)

      # Set armor specials gained from spells
      if specials && combatant.spell_armor_effects[armor]
        spell_specials = combatant.spell_armor_effects[armor].keys
        specials = specials.concat spell_specials
      elsif combatant.spell_armor_effects[armor]
        specials = combatant.spell_armor_effects[armor].keys
      end

      combatant.update(armor_name: armor ? armor.titlecase : nil)
      combatant.update(armor_specials: specials ? specials.map { |s| s.titlecase }.uniq : [])
      message = t('fs3combat.armor_changed', :name => combatant.name, :armor => combatant.armor)
      FS3Combat.emit_to_combat combatant.combat, message, FS3Combat.npcmaster_text(combatant.name, enactor)
    end

  end
end
