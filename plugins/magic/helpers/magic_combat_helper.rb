require 'byebug'
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
      off_school_cast_mod = Magic.spell_skill(combatant, spell)[:cast_mod]
      spell_mod = combatant.spell_mod || 0

      #Item mods
      item_attack_mod = Magic.item_attack_mod(combatant.associated_model)
      item_spell_mod = Magic.item_spell_mod(combatant.associated_model)
      
      #Luck mods
      attack_luck_mod = (combatant.luck == "Attack") ? 3 : 0
      spell_luck_mod = (combatant.luck == "Spell") ? 3 : 0
      
      skill = Magic.spell_skill(combatant, spell)[:skill]
      
      total_mod = accuracy_mod + attack_mod + damage_mod + distraction_mod + stance_mod - stress_mod + level_mod + gm_spell_mod + magic_attack_mod + off_school_cast_mod + spell_mod + item_attack_mod + item_spell_mod + attack_luck_mod + spell_luck_mod

      combatant.log "SPELL ROLL for #{combatant.name} skill=#{skill} |FS3 MODS| accuracy=#{accuracy_mod} attack=#{attack_mod} damage=#{damage_mod} distraction=#{distraction_mod} stance=#{stance_mod} stress=-#{stress_mod} |MAGIC_MODS| level=#{level_mod} gm_spell=#{gm_spell_mod} magic_attack=#{magic_attack_mod} off_school_cast=#{off_school_cast_mod} spell_mod=#{spell_mod} item_attack=#{item_attack_mod} item_spell_mod=#{item_spell_mod} |LUCK MODS| attack_luck=#{attack_luck_mod} spell_luck=#{spell_luck_mod} total_mod=#{total_mod}"

      die_result = combatant.roll_ability(skill, total_mod)
      succeeds = Magic.spell_success(spell, die_result)
      return {:succeeds => succeeds, :result => die_result}
    end

    # def self.shield_failed_stun_successful?(attacker_net_successes)
    #   #Fix how this works - it's dumb to break this out and I'm not sure the logic is sound
    #   return  attacker_net_successes > 0
    #   return false
    # end

    def self.magic_damage_type(weapon_or_spell)
      Global.read_config("spells", weapon_or_spell, "damage_type") || FS3Combat.weapon_stat(weapon_or_spell, "magic_damage_type") || Global.read_config("magic", "default_damage_type")
    end

    def self.spell_newturn(combatant)

      Magic.shield_newturn_countdown(combatant)
      mods = []
      messages = []
      #Stances suck, let's just take them out
      # if (combatant.magic_stance_counter == 0 && combatant.magic_stance_spell)

      # elsif (combatant.magic_stance_counter > 0 && combatant.magic_stance_spell)
      #   combatant.update(magic_stance_counter: combatant.magic_stance_counter - 1)
      # end
      # byebug
      if combatant.magic_stun
        msg = Magic.stun_newturn(combatant)
        messages.concat [msg]
      end

      if combatant.magic_attack_mod != 0 
        msg = Magic.magic_attack_mod_newturn(combatant)
        mods.concat [msg]
      end

      if combatant.magic_defense_mod != 0
        msg = Magic.magic_defense_mod_newturn(combatant)
        mods.concat [msg]
      end

      if combatant.magic_init_mod > 0
        msg = Magic.magic_init_mod_newturn(combatant)
        mods.concat [msg]
      end

      if combatant.magic_lethal_mod != 0
        msg = Magic.magic_lethal_mod_newturn(combatant)
        mods.concat [msg]
      end

      if combatant.spell_mod != 0
        msg = Magic.magic_spell_mod_newturn(combatant)
        mods.concat [msg]
      end

      if !combatant.is_npc? && combatant.associated_model.auto_revive? && combatant.is_ko
        msg = Magic.magic_auto_revive(combatant)
        messages.concat [msg]
      end

      if !mods.empty? && mods.count > 1
        messages.concat  [t('magic.mods_wore_off', :name => combatant.name, :mods => mods.join(", "))] 
      elsif !mods.empty?
        messages.concat  [t('magic.mod_wore_off', :name => combatant.name, :mods => mods.join())]
      end
      # byebug

      FS3Combat.emit_to_combat combatant.combat, messages.join("\n"), nil, true

    end

    # def self.stance_newturn_countdown(combatant)
    #   stance = Global.read_config("spells", combatant.magic_stance_spell, "stance")
    #   stance_msg = "in cover" if stance == "cover"

    #   messages.concat [t('magic.stance_wore_off', :name => combatant.name, :spell => combatant.magic_stance_spell, :stance => stance_msg)]
    #   combatant.log "#{combatant.name} #{combatant.magic_stance_spell} wore off."
    #   combatant.update(magic_stance_spell: nil)
    #   combatant.update(stance: "Normal")
    
    # end

    def self.stun_newturn(combatant)
      if combatant.magic_stun_counter == 0
        combatant.update(magic_stun: false)
        combatant.update(magic_stun_spell: nil)
        combatant.log "#{combatant.name} is no longer magically stunned."
        return t('magic.stun_wore_off', :name => combatant.name)
      else
        subduer = combatant.subdued_by
        #Does this return math right? Does the update need to go after the msg?
        combatant.update(magic_stun_counter: combatant.magic_stun_counter - 1)
        return t('magic.still_stunned', :name => combatant.name, :stunned_by => subduer.name, :rounds => combatant.magic_stun_counter)
      end
    end

    def self.magic_attack_mod_newturn(combatant)
      if combatant.magic_attack_mod_counter == 0 
        msg = "#{combatant.magic_attack_mod} attack"
        combatant.update(magic_attack_mod: 0)
        combatant.log "#{combatant.name} resetting attack mod to #{combatant.magic_attack_mod}."
        return msg
      else
        combatant.update(magic_attack_mod_counter: combatant.magic_attack_mod_counter - 1)
      end
    end

    def self.magic_defense_mod_newturn(combatant)
      if combatant.magic_defense_mod_counter == 0 
        msg = "#{combatant.magic_defense_mod} defense"
        combatant.update(magic_defense_mod: 0)
        combatant.log "#{combatant.name} resetting defense mod to #{combatant.magic_defense_mod}."
        return msg
      else
        combatant.update(magic_defense_mod_counter: combatant.magic_defense_mod_counter - 1)
      end
    end

    def self.magic_init_mod_newturn(combatant)
      if combatant.magic_init_mod_counter == 0 
        msg = "#{combatant.magic_init_mod} initiative"
        combatant.update(magic_init_mod: 0)
        combatant.log "#{combatant.name} resetting initiative mod to #{combatant.magic_init_mod}."
        return msg
      elsif combatant.magic_init_mod_counter > 0 
        combatant.update(magic_init_mod_counter: combatant.magic_init_mod_counter - 1)
      end
    end

    def self.magic_lethal_mod_newturn(combatant)
      if combatant.magic_lethal_mod_counter == 0 
        msg = "#{combatant.magic_lethal_mod} lethality"
        combatant.update(magic_lethal_mod: 0)
        combatant.log "#{combatant.name} resetting lethality mod to #{combatant.magic_lethal_mod}."
        return msg
      else
        combatant.update(magic_lethal_mod_counter: combatant.magic_lethal_mod_counter - 1)
      end
    end

    def self.magic_spell_mod_newturn(combatant)
      if combatant.spell_mod_counter == 0 
        msg = "#{combatant.spell_mod} spell"
        combatant.update(spell_mod: 0)
        combatant.log "#{combatant.name} resetting spell mod to #{combatant.spell_mod}."
        return msg
      else
        combatant.update(spell_mod_counter: combatant.spell_mod_counter - 1)
      end
    end

    def self.magic_auto_revive(combatant)      
      auto_revive_spell = combatant.associated_model.auto_revive?
      combatant.update(action_klass: "AresMUSH::FS3Combat::SpellAction")
      combatant.update(action_args: "#{auto_revive_spell}/#{combatant.name}")
      return t('magic.spell_action_msg_long', :name => combatant.name, :spell => auto_revive_spell)
    end




  end
end
