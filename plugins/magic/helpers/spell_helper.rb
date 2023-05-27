module AresMUSH
  module Magic

    attr_accessor :targets

    def self.log_magic_msg(char_or_combatant, msg)
      if (char_or_combatant.class == Combatant)
        char_or_combatant.log msg
      else
        Global.logger.info msg
      end
    end

    def self.spell_max
      Global.read_config("magic", "spell_max")
    end

    def self.is_spell?(spell)
      spell_list = Global.read_config("spells")
      spell_name = spell.titlecase
      if (spell_name == "Potions" || spell_name == "Familiar")
        return false
      else
        spell_list.include?(spell_name)
      end
    end

    def self.find_spell_school(spell_name)
      Global.read_config("spells", spell_name.titlecase, "school")
    end

    def self.find_spell_level(char, spell_name)
      Global.read_config("spells", spell_name.titlecase, "level")
    end

    def self.handle_spell_cast_achievement(char)
      char.update(spells_cast: char.spells_cast + 1)
      [ 1, 10, 20, 50, 100, 200, 300, 400, 500, 600 ].each do |count|
        if (char.spells_cast >= count)
          Achievements.award_achievement(char, "spells_cast", count)
        end
      end
    end

    def self.handle_spell_learn_achievement(char)
      char.update(achievement_spells_learned: char.achievement_spells_learned + 1)
      [ 1, 10, 20, 30, 40, 50 ].each do |count|
        if (char.achievement_spells_learned >= count)
          Achievements.award_achievement(char, "spells_learned", count)
        end
      end
    end

    def self.handle_spell_discard_achievement(char)
      char.update(achievement_spells_discarded: char.achievement_spells_discarded + 1)
      [ 1, 5, 15, 20, 25 ].each do |count|
        if (char.achievement_spells_discarded >= count)

          Achievements.award_achievement(char, "spells_discarded", count)
        end
      end
    end

    def self.spell_success(die_result)
      if die_result < 1
        return "%xrFAILS%xn"
      else
        return "%xgSUCCEEDS%xn"
      end
    end

    def self.parse_spell_targets(name_string, npc = false)
      #In combat, use FS3.parse_targets and then run the targets through spell_target_errors
      target_names = name_string.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
      targets = []
      target_names.each do |name|
        target = Character.named(name) || Mount.named(name)
        return t('magic.invalid_name') if (!target && !npc)
        return "npc_target" if npc
        targets << target
      end
      return targets
    end

    def self.spell_target_errors(enactor, targets, spell)
      # spell/npc is targeting the npc who cast the spell
      return false if targets == "npc_target"
      return t('magic.invalid_name') if targets == t('magic.invalid_name')
      target_num = Global.read_config("spells", spell, "target_num") || 1
      return t('magic.too_many_targets', :spell => spell, :num => target_num ) if targets.count > target_num
      energy_points = Global.read_config("spells", spell, "energy_points")
      return t('magic.cant_spell_fatigue_heal_yourself') if targets.include?(enactor) && energy_points

      heal_points = Global.read_config("spells", spell, "heal_points")
      targets.each do |target|
        if heal_points
          wound = FS3Combat.worst_treatable_wound(target)
          return t('magic.no_healable_wounds', :target => target.name) if wound.blank?
        end
        if energy_points
          puts "energy points"
        end
        if target.magic_energy >= (target.total_magic_energy * 0.8)
          puts "no more healing"
        end
        return t('magic.cannot_spell_fatigue_heal_further', :name => target.name) if (energy_points && (target.magic_energy >= (target.total_magic_energy * 0.8)))
      end

      return false
    end

    def self.print_target_names(targets)
      return nil if targets == "npc_target"
      target_names = targets.map { |t| t.name}
      target_names.join(", ")
    end

    # def self.target_errors(caster, targets, spell)
    #   target_num = Global.read_config("spells", spell, "target_num")
    #   heal_points = Global.read_config("spells", spell, "heal_points")
    #   if targets == "no_target"
    #     return t('magic.invalid_name')
    #   elsif targets == "too_many_targets"
    #     return t('magic.too_many_targets', :spell => spell, :num => target_num )
    #   elsif targets == "npc_target"
    #     return false
    #   else
    #     targets.each do |target|
    #       wound = FS3Combat.worst_treatable_wound(target)
    #       # if (target == caster && Global.read_config("spells", spell, "fs3_attack"))
    #       #   return  t('magic.dont_target_self')
    #       if (heal_points && wound.blank? && caster.combat)
    #         return t('magic.no_healable_wounds', :target => target.name)
    #       else
    #         return nil
    #       end
    #     end
    #   end
    # end

    def self.roll_noncombat_spell(caster, spell, mod = nil)
      skill = Magic.spell_skill(caster, spell)[:skill]
      cast_mod = Magic.spell_skill(caster, spell)[:cast_mod]
      level_mod = Magic.spell_level_mod(spell)
      item_spell_mod = Magic.item_spell_mod(caster)
      magic_energy_mod = Magic.get_magic_energy_mod(caster)

      total_mod = mod.to_i + cast_mod + item_spell_mod.to_i + level_mod + magic_energy_mod

      Global.logger.info "#{caster.name} rolling #{skill} to cast #{spell}. Level Mod=#{level_mod} Mod=#{mod} Item Mod=#{item_spell_mod} Off-school cast mod=#{cast_mod} Magic Energy Mod=#{magic_energy_mod} total=#{total_mod}"
      #result is logged in Character.roll_ability



      roll = caster.roll_ability(skill, total_mod)
      die_result = roll[:successes]
      succeeds = Magic.spell_success(die_result)

      messages = []
      puts "~~~~MAGIC ENERGY BEFORE SUBTRACTION: #{caster.magic_energy}"
      start_fatigue = Magic.get_fatigue_level(caster)[:degree]
      Magic.subtract_magic_energy(caster, spell, succeeds)
      puts "~~~~MAGIC ENERGY AFTER SUBTRACTION: #{caster.magic_energy}"
      fatigue_msg = Magic.get_fatigue_level(caster)[:msg]
      final_fatigue = Magic.get_fatigue_level(caster)[:degree]
      serious_degrees = ["Severe", "Extreme", "Total"]

      if start_fatigue != final_fatigue || serious_degrees.include?(final_fatigue)
        messages.concat [Magic.get_fatigue_level(caster)[:msg]]
      end

      return {
        succeeds: succeeds,
        result: die_result,
        messages: messages,
      }
    end

    def self.roll_npc_spell(npc_name, spell, dice)
      #spell/npc out of combat roll
      roll = FS3Skills.roll_dice(dice)
      die_result = FS3Skills.get_success_level(roll)
      succeeds = Magic.spell_success(die_result)
      Global.logger.info "#{npc_name} (NPC) rolling #{dice} dice to cast #{spell}. Result: #{roll} (#{die_result} successes)"
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
