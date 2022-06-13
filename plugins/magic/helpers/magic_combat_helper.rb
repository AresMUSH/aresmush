module AresMUSH
  module Magic

    def self.get_associated_model(char_or_combatant)
      return char_or_combatant.associated_model if char_or_combatant.class == Combatant
      return char_or_combatant
    end

    def self.roll_combat_spell(combatant, spell, cast_mod = 0)
      #FS3 mods
      accuracy_mod = FS3Combat.weapon_stat(combatant.weapon, "accuracy")
      attack_mod = combatant.attack_mod      
      damage_mod = combatant.total_damage_mod
      distraction_mod = combatant.distraction
      stance_mod = combatant.attack_stance_mod
      stress_mod = combatant.stress
      
      #Magic mods
      level_mod = Magic.spell_level_mod(spell)
      gm_spell_mod = combatant.gm_spell_mod
      magic_attack_mod = combatant.magic_attack_mod
      off_school_cast_mod = Magic.spell_skill(caster_combatant, spell)[:cast_mod]
      spell_mod = combatant.spell_mod || 0

      #Item mods
      item_attack_mod = Magic.item_attack_mod(combatant.associated_model)
      item_spell_mod = Magic.item_spell_mod(combatant.associated_model)
      
      #Luck mods
      attack_luck_mod = (combatant.luck == "Attack") ? 3 : 0
      spell_luck_mod = (combatant.luck == "Spell") ? 3 : 0
 
      skill = Magic.spell_skill(caster_combatant, spell)[:skill]
      
      total_mod = accuracy_mod + attack_mod + damage_mod + distraction_mod + stance_mod + stress_mod + level_mod + gm_spell_mod + magic_attack_mod + off_school_cast_mod + spell_mod + item_attack_mod + item_spell_mod + attack_luck_mod + spell_luck_mod

      combatant.log "SPELL ROLL for #{combatant.name} skill=#{skill} |FS3 MODS| accuracy=#{accuracy_mod} attack=#{attack_mod} damage=#{damage_mod} distraction=#{distraction_mod} stance=#{stance_mod} stress=#{stress_mod} |MAGIC_MODS| level=#{level_mod} gm_spell=#{gm_spell_mod} magic_attack=#{magic_attack_mod} off_school_cast=#{off_school_cast_mod} spell_mod=#{spell_mod} item_attack=#{item_attack_mod} item_spell_mod=#{item_spell_mod} |LUCK MODS| attack_luck=#{attack_luck_mod} spell_luck=#{spell_luck_mod} total_mod=#{total_mod}"

      die_result = combatant.roll_ability(school, total_mod)
      succeeds = Magic.spell_success(spell, die_result)
      return {:succeeds => successes, :result => die_result}
    end

    def self.stun_successful?(hit, attacker_net_successes)
      return true if hit && attacker_net_successes > 0
      return false
    end

    def self.magic_damage_type(weapon_or_spell)
      Global.read_config("spells", weapon_or_spell, "damage_type") || FS3Combat.weapon_stat(weapon_or_spell, "magic_damage_type") || Global.read_config("magic", "default_damage_type")
    end

    def self.spell_newturn(combatant)

      Magic.shield_newturn_countdown(combatant)
      mods = []
      messages = []

      if (combatant.magic_stance_counter == 0 && combatant.magic_stance_spell)
        stance = Global.read_config("spells", combatant.magic_stance_spell, "stance")
        if stance == "cover"
          stance = "in cover"
        end
        messages.concat [t('magic.stance_wore_off', :name => combatant.name, :spell => combatant.magic_stance_spell, :stance => stance)]
        combatant.log "#{combatant.name} #{combatant.magic_stance_spell} wore off."
        combatant.update(magic_stance_spell: nil)
        combatant.update(stance: "Normal")
      elsif (combatant.magic_stance_counter > 0 && combatant.magic_stance_spell)
        combatant.update(magic_stance_counter: combatant.magic_stance_counter - 1)
      end

      if (combatant.magic_stun_counter == 0 && combatant.magic_stun)
        messages.concat [t('magic.stun_wore_off', :name => combatant.name)]
        combatant.update(magic_stun: false)
        combatant.update(magic_stun_spell: nil)
        combatant.log "#{combatant.name} is no longer magically stunned."
      elsif (combatant.magic_stun_counter > 0 && combatant.magic_stun)
        subduer = combatant.subdued_by
        messages.concat [t('magic.still_stunned', :name => combatant.name, :stunned_by => subduer.name, :rounds => combatant.magic_stun_counter)]
        combatant.update(magic_stun_counter: combatant.magic_stun_counter - 1)
      end

      if combatant.magic_attack_mod_counter == 0 && combatant.magic_attack_mod != 0
        mods.concat ["#{combatant.magic_attack_mod} attack"]
        combatant.update(magic_attack_mod: 0)
        combatant.log "#{combatant.name} resetting attack mod to #{combatant.magic_attack_mod}."
      else
        combatant.update(magic_attack_mod_counter: combatant.magic_attack_mod_counter - 1)
      end

      if combatant.magic_defense_mod_counter == 0 && combatant.magic_defense_mod != 0
        mods.concat ["#{combatant.magic_defense_mod} defense"]
        combatant.update(magic_defense_mod: 0)
        combatant.log "#{combatant.name} resetting defense mod to #{combatant.magic_defense_mod}."
      else
        combatant.update(magic_defense_mod_counter: combatant.magic_defense_mod_counter - 1)
      end

      if (combatant.magic_init_mod_counter == 0 && combatant.magic_init_mod > 0)
        mods.concat ["#{combatant.magic_init_mod} initiative"]
        combatant.update(magic_init_mod: 0)
        combatant.log "#{combatant.name} resetting initiative mod to #{combatant.magic_init_mod}."
      elsif (combatant.magic_init_mod_counter > 0 && combatant.magic_init_mod > 0)
        combatant.update(magic_init_mod_counter: combatant.magic_init_mod_counter - 1)
      end

      if combatant.magic_lethal_mod_counter == 0 && combatant.magic_lethal_mod != 0
        mods.concat ["#{combatant.magic_lethal_mod_counter} lethality"]
        combatant.update(magic_lethal_mod: 0)
        combatant.log "#{combatant.name} resetting lethality mod to #{combatant.magic_lethal_mod}."
      else
        combatant.update(magic_lethal_mod_counter: combatant.magic_lethal_mod_counter - 1)
      end

      if combatant.spell_mod_counter == 0 && combatant.spell_mod != 0
        mods.concat ["#{combatant.spell_mod} spell"]
        combatant.update(spell_mod: 0)
        combatant.log "#{combatant.name} resetting spell mod to #{combatant.spell_mod}."
      else
        combatant.update(spell_mod_counter: combatant.spell_mod_counter - 1)
      end

      if !combatant.is_npc? && combatant.associated_model.auto_revive? && combatant.is_ko
        auto_revive_spell = combatant.associated_model.auto_revive?
        combatant.update(action_klass: "AresMUSH::FS3Combat::SpellAction")
        combatant.update(action_args: "#{auto_revive_spell}/#{combatant.name}")
        messages.concat [t('magic.spell_action_msg_long', :name => combatant.name, :spell => auto_revive_spell)]
      end

      if !mods.empty?
        if mods.count > 1
          mods = mods.join(", ")
          messages.concat  [t('magic.mods_wore_off', :name => combatant.name, :mods => mods)]
        else
          mods = mods.join()
          messages.concat  [t('magic.mod_wore_off', :name => combatant.name, :mods => mods)]
        end
      end

      messages.uniq.each do |msg|
        FS3Combat.emit_to_combat(combatant.combat, msg, nil, true)
      end

    end


  end
end
