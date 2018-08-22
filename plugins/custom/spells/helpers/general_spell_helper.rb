module AresMUSH
  module Custom

    def self.is_spell?(spell)
      spell_list = Global.read_config("spells")
      spell_name = spell.titlecase
      spell_list.include?(spell_name)
    end

    def self.already_cast(caster_combat)
      has_cast = caster_combat.has_cast
      return true if has_cast
    end

    def self.roll_combat_spell(char, combatant, school)
      accuracy_mod = FS3Combat.weapon_stat(combatant.weapon, "accuracy")
      special_mod = combatant.attack_mod
      damage_mod = combatant.total_damage_mod
      stance_mod = combatant.attack_stance_mod
      stress_mod = combatant.stress
      luck_mod = (combatant.luck == "Attack") ? 3 : 0
      distraction_mod = combatant.distraction
      spell_mod = combatant.spell_mod


      combatant.log "Attack roll for #{combatant.name} school=#{school} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod} luck=#{luck_mod} stress=#{stress_mod} special=#{special_mod} distract=#{distraction_mod}"

      mod = spell_mod.to_i + accuracy_mod.to_i + damage_mod.to_i  + stance_mod.to_i  + luck_mod.to_i  - stress_mod.to_i  + special_mod.to_i  - distraction_mod.to_i

      successes = combatant.roll_ability(school, mod)
      return successes

    end

    def self.combat_spell_success(spell, die_result)
      spell_level = Global.read_config("spells", spell, "level")
      if die_result < 1
        return "%xrFAILS%xn"
      elsif spell_level == 1
        return "%xrFAILS%xn" if die_result == 1
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 2
        return "%xrFAILS%xn" if die_result <= 1
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 3
        return "%xrFAILS%xn" if die_result <= 2
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 4
        return "%xrFAILS%xn" if die_result <= 2
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 5
        return "%xrFAILS%xn" if die_result <= 3
        return "%xgSUCCEEDS%xn"
      elsif spell_level == 6
        return "%xrFAILS%xn" if die_result <= 3
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

    def self.roll_combat_spell_success(caster, spell)
      school = Global.read_config("spells", spell, "school")
      die_result = Custom.roll_combat_spell(caster, caster, school)
      succeeds = Custom.combat_spell_success(spell, die_result)
    end

  end
end
