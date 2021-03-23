module AresMUSH
  module Magic

    def self.roll_combat_spell(char, combatant, school, cast_mod = 0, level_mod)
      accuracy_mod = FS3Combat.weapon_stat(combatant.weapon, "accuracy")
      attack_mod = combatant.attack_mod
      magic_attack_mod = combatant.magic_attack_mod
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
      total_mod = cast_mod + item_spell_mod.to_i + item_attack_mod.to_i + gm_spell_mod.to_i + spell_mod.to_i + accuracy_mod.to_i + damage_mod.to_i  + stance_mod.to_i  + attack_luck_mod.to_i  + spell_luck_mod.to_i - stress_mod.to_i  + magic_attack_mod.to_i + attack_mod.to_i - distraction_mod.to_i + level_mod.to_i

      combatant.log "SPELL ROLL for #{combatant.name} school=#{school} level_mod=#{level_mod} off-school_cast_mod=#{cast_mod} spell_mod=#{spell_mod} spell_luck=#{spell_luck_mod} gm_spell_mod=#{gm_spell_mod} item_spell_mod=#{item_spell_mod} attack=#{attack_mod} magic_attack=#{magic_attack_mod} item_attack_mod=#{item_attack_mod} attack_luck=#{attack_luck_mod} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod}   stress=#{stress_mod}  distract=#{distraction_mod} total_mod=#{total_mod}"

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

    def self.stun_successful?(hit, attacker_net_successes)
      if hit && attacker_net_successes > 0
        puts "Stun successful"
        return true
      else
        puts "Stun failed"
        return false
      end
    end

    def self.magic_damage_type(weapon_or_spell)
      Global.read_config("spells", weapon_or_spell, "damage_type") || FS3Combat.weapon_stat(weapon_or_spell, "magic_damage_type") || Global.read_config("magic", "default_damage_type")
    end



  end
end
