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
      [ 1, 10, 20, 50, 100, 200, 300, 400 ].each do |count|
        if (char.spells_cast >= count)
          # if (count == 1)
          #   message = "Cast a spell."
          # else
          #   message = "Cast #{count} spells."
          # end
          Achievements.award_achievement(char, "spells_cast", count)
        end
      end
    end

    def self.handle_spell_learn_achievement(char)
      char.update(achievement_spells_learned: char.achievement_spells_learned + 1)
      [ 1, 10, 20, 30, 40, 50 ].each do |count|
        if (char.achievement_spells_learned >= count)
          # if (count == 1)
          #   message = "Learned a spell."
          # else
          #   message = "Learned #{count} spells."
          # end
          Achievements.award_achievement(char, "spells_learned", count)
        end
      end
    end

    def self.handle_spell_discard_achievement(char)
      char.update(achievement_spells_discarded: char.achievement_spells_discarded + 1)
      [ 1, 5, 15, 20, 25 ].each do |count|
        if (char.achievement_spells_discarded >= count)
          # if (count == 1)
          #   message = "Learned a spell."
          # else
          #   message = "Learned #{count} spells."
          # end
          Achievements.award_achievement(char, "spells_discarded", count)
        end
      end
    end

    def self.spell_success(spell, die_result)
      if die_result < 1
        return "%xrFAILS%xn"
      else
        return "%xgSUCCEEDS%xn"
      end
    end

    def self.parse_spell_targets(name_string, spell, npc = nil)
      target_num = Global.read_config("spells", spell, "target_num") || 1
      return t('fs3combat.no_targets_specified') if (!name_string)
      target_names = name_string.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
      targets = []
      target_names.each do |name|
        target = Character.named(name)
        if (!target && !npc)
          return "no_target"
        elsif npc == name
         return "npc_target"
        end
        targets << target
      end
      targets = targets
      if (targets.count > target_num)
        return "too_many_targets"
      else
        return targets
      end
    end

    def self.print_target_names(name_string)
      target_names = name_string.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
      print_names = []
      target_names.each do |name|
        target = Character.named(name)
        return "no_target" if !target
        print_names << target.name
      end
      print_names = print_names.join(", ")
      return print_names
    end

    def self.target_errors(caster, targets, spell)
      target_num = Global.read_config("spells", spell, "target_num")
      heal_points = Global.read_config("spells", spell, "heal_points")
      if targets == "no_target"
        return t('magic.invalid_name')
      elsif targets == "too_many_targets"
        return t('magic.too_many_targets', :spell => spell, :num => target_num )
      elsif targets == "npc_target"
        return false
      else
        targets.each do |target|
          wound = FS3Combat.worst_treatable_wound(target)
          # if (target == caster && Global.read_config("spells", spell, "fs3_attack"))
          #   return  t('magic.dont_target_self')
          if (heal_points && wound.blank? && caster.combat)
            return t('magic.no_healable_wounds', :target => target.name)
          else
            return nil
          end
        end
      end
    end

    def self.roll_noncombat_spell_success(caster_name, spell, mod = nil, dice = nil)
      if Character.named(caster_name)
        caster = Character.named(caster_name)
      else
        caster = caster_name
        is_npc = true
      end
      if is_npc
        roll = FS3Skills.roll_dice(dice)
        die_result = FS3Skills.get_success_level(roll)
        succeeds = Magic.spell_success(spell, die_result)
        Global.logger.info "#{caster_name} rolling #{dice} dice to cast #{spell}. Result: #{roll} (#{die_result} successes)"
      else
        schools = [caster.group("Minor School"), caster.group("Major School")]
        school = Global.read_config("spells", spell, "school")
        if schools.include?(school)
          skill = school
        else
          skill = "Magic"
          cast_mod = FS3Skills.ability_rating(caster, "Magic") * 2
          mod = mod.to_i + cast_mod
        end
        level = Global.read_config("spells", spell, "level")
        if level == 1
          level_mod = 0
        else
          level_mod = 0 - level
        end
        spell_mod = Magic.item_spell_mod(caster)
        total_mod = mod.to_i + spell_mod.to_i + level_mod.to_i
        Global.logger.info "#{caster.name} rolling #{skill} to cast #{spell}. Level Mod=#{level_mod} Mod=#{mod} Item Mod=#{spell_mod} Off-school cast mod=#{cast_mod} total=#{total_mod}"
        roll = caster.roll_ability(skill, total_mod)
        die_result = roll[:successes]
        succeeds = Magic.spell_success(spell, die_result)
      end

      return {:succeeds => succeeds, :result => die_result}
    end



    def self.heal_all_unhealed_damage(char)
      wounds = char.damage.select { |d| d.healing_points > 0 }
      wounds.each do |w|
        w.update(current_severity: "HEAL")
        w.update(healed: true)
        w.update(healing_points: 0)
      end
      Global.logger.info "Auto-revive spell healing all #{char.name}'s damage."
    end

  end
end
