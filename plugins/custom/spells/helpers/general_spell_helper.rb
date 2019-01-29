module AresMUSH
  module Custom

    def self.is_spell?(spell)
      spell_list = Global.read_config("spells")
      spell_name = spell.titlecase
      if (spell_name == "Potions" || spell_name == "Familiar")
        return false
      else
        spell_list.include?(spell_name)
      end
    end

    def self.handle_spell_cast_achievement(char)
      char.update(spells_cast: char.spells_cast + 1)
      [ 1, 10, 20, 50, 100 ].each do |count|
        if (char.spells_cast >= count)
          if (count == 1)
            message = "Cast a spell."
          else
            message = "Cast #{count} spells."
          end
          Achievements.award_achievement(char, "cast_spells_#{count}", 'spell', message)
        end
      end
    end

    def self.handle_spell_learn_achievement(char)
      char.update(achievement_spells_learned: char.achievement_spells_learned + 1)
      [ 1, 10, 20, 30 ].each do |count|
        if (char.achievement_spells_learned >= count)
          if (count == 1)
            message = "Learned a spell."
          else
            message = "Learned #{count} spells."
          end
          Achievements.award_achievement(char, "learned_spells_#{count}", 'spell', message)
        end
      end
    end

    # def self.already_cast(caster_combat)
    #   has_cast = caster_combat.has_cast
    #   return true if has_cast
    # end

    def parse_heal_targets(name_string)
      return t('fs3combat.no_targets_specified') if (!name_string)
      target_names = name_string.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
      targets = []
      target_names.each do |name|
        target = self.combat.find_named_thing(name)
        return t('fs3combat.not_in_combat', :name => name) if !target
        return t('fs3combat.cant_target_noncombatant', :name => name) if target.is_noncombatant?
        targets << target
      end
      self.targets = targets
      return nil
    end

    #Can read armor or weapon
    def self.is_magic_weapon(gear)
      FS3Combat.weapon_stat(gear, "is_magic")
    end

    def self.is_magic_armor(gear)
      FS3Combat.armor_stat(gear, "is_magic")
    end


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
        item_spell_mod = Custom.item_spell_mod(combatant.associated_model)
      else
        item_spell_mod = 0
      end


      combatant.log "Spell roll for #{combatant.name} school=#{school} mod=#{mod} spell_mod=#{spell_mod} item_spell_mod=#{item_spell_mod} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod} attack_luck=#{attack_luck_mod} spell_luck=#{spell_luck_mod} stress=#{stress_mod} special=#{special_mod} distract=#{distraction_mod}"

      mod = mod + item_spell_mod.to_i + spell_mod.to_i + accuracy_mod.to_i + damage_mod.to_i  + stance_mod.to_i  + attack_luck_mod.to_i  + spell_luck_mod.to_i - stress_mod.to_i  + special_mod.to_i - distraction_mod.to_i

      successes = combatant.roll_ability(school, mod)
      return successes

    end

    def self.combat_spell_success(spell, die_result)
      spell_level = Global.read_config("spells", spell, "level")
      if spell_level == 1
        return "%xrFAILS%xn" if die_result < 1
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 2
        return "%xrFAILS%xn" if die_result < 1
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 3
        return "%xrFAILS%xn" if die_result <= 1
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 4
        return "%xrFAILS%xn" if die_result <= 1
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 5
        return "%xrFAILS%xn" if die_result <= 2
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 6
        return "%xrFAILS%xn" if die_result <= 2
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 7
        return "%xrFAILS%xn" if die_result <= 3
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 8
        return "%xrFAILS%xn" if die_result <= 1
        return "%xgSUCCEEDS%xn"
      else
        return "%xgSUCCEEDS%xn"
      end
    end

    def self.roll_combat_spell_success(caster_combat, spell)
      if caster_combat.npc
        school = Global.read_config("spells", spell, "school")
        mod = 0
      elsif Custom.knows_spell?(caster_combat.associated_model, spell)
        school = Global.read_config("spells", spell, "school")
        mod = 0
      else
        school = "Magic"
        mod = FS3Skills.ability_rating(caster_combat.associated_model, "Magic") * 2
      end

      die_result = Custom.roll_combat_spell(caster_combat, caster_combat, school, mod)
      succeeds = Custom.combat_spell_success(spell, die_result)
    end

    def self.roll_noncombat_spell_success(caster, spell, mod = nil)
      if Custom.knows_spell?(caster, spell)
        school = Global.read_config("spells", spell, "school")
      else
        school = "Magic"
        cast_mod = FS3Skills.ability_rating(caster, "Magic") * 2
        Global.logger.debug "Mod: #{mod}"
        Global.logger.debug "Cast Mod: #{cast_mod}"
        mod = mod.to_i + cast_mod
      end

      spell_mod = Custom.item_spell_mod(caster)
      total_mod = mod.to_i + spell_mod.to_i
      roll = caster.roll_ability(school, total_mod)
      die_result = roll[:successes]
      succeeds = Custom.combat_spell_success(spell, die_result)
    end

    def self.delete_all_untreated_damage(char)
      damage = char.damage
      damage.each do |d|
        if !d.healed
          d.delete
        end
        Global.logger.info "Phoenix's Healing Flames deleting #{char.name}'s' damage."
      end
    end

  end
end
