module AresMUSH
  module Magic

    def self.is_spell?(spell)
      spell_list = Global.read_config("spells")
      spell_name = spell.titlecase
      if (spell_name == "Potions" || spell_name == "Familiar")
        return false
      else
        spell_list.include?(spell_name)
      end
    end

    def self.find_spell_school(char, spell_name)
      Global.read_config("spells", spell_name.titlecase, "school")
    end

    def self.find_spell_level(char, spell_name)
      Global.read_config("spells", spell_name.titlecase, "level")
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

    #Can read armor or weapon
    def self.is_magic_weapon(gear)
      FS3Combat.weapon_stat(gear, "is_magic")
    end

    def self.is_magic_armor(gear)
      FS3Combat.armor_stat(gear, "is_magic")
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

    def self.roll_combat_spell_success(caster_combatant, spell)
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
      succeeds = Magic.combat_spell_success(spell, die_result)
    end

    def self.roll_noncombat_spell_success(caster, spell, mod = nil)
      if Magic.knows_spell?(caster, spell)
        school = Global.read_config("spells", spell, "school")
      else
        school = "Magic"
        cast_mod = FS3Skills.ability_rating(caster, "Magic") * 2
        mod = mod.to_i + cast_mod
      end

      spell_mod = Magic.item_spell_mod(caster)
      total_mod = mod.to_i + spell_mod.to_i
      Global.logger.info "#{caster.name} rolling #{school} to cast #{spell}. Mod=#{mod} Item Mod=#{spell_mod} Off-school cast mod=#{cast_mod}"
      roll = caster.roll_ability(school, total_mod)
      die_result = roll[:successes]
      succeeds = Magic.combat_spell_success(spell, die_result)
    end

    def self.delete_all_untreated_damage(char)
      damage = char.damage
      damage.each do |d|
        if !d.healed
          d.delete
        end
        Global.logger.info "Phoenix's Healing Flames deleting #{char.name}'s damage."
      end
    end

  end
end
