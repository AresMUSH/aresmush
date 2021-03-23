module AresMUSH
  module Magic

    def self.spell_newturn(combatant)

      Magic.shield_newturn_countdown(combatant)

      if (combatant.magic_init_mod_counter == 0 && combatant.magic_init_mod > 0)
        FS3Combat.emit_to_combat combatant.combat, t('magic.mod_wore_off', :name => combatant.name, :type => "initiative", :mod => combatant.magic_init_mod), nil, true
        combatant.update(magic_init_mod: 0)
        combatant.log "#{combatant.name} resetting initiative mod to #{combatant.magic_init_mod}."
      elsif (combatant.magic_init_mod_counter > 0 && combatant.magic_init_mod > 0)
        combatant.update(magic_init_mod_counter: combatant.magic_init_mod_counter - 1)
      end

      if (combatant.magic_stance_counter == 0 && combatant.magic_stance_spell)
        stance = Global.read_config("spells", combatant.magic_stance_spell, "stance")
        if stance == "cover"
          stance = "in cover"
        end
        FS3Combat.emit_to_combat combatant.combat, t('magic.stance_wore_off', :name => combatant.name, :spell => combatant.magic_stance_spell, :stance => stance), nil, true
        combatant.log "#{combatant.name} #{combatant.magic_stance_spell} wore off."
        combatant.update(magic_stance_spell: nil)
        combatant.update(stance: "Normal")
      elsif (combatant.magic_stance_counter > 0 && combatant.magic_stance_spell)
        combatant.update(magic_stance_counter: combatant.magic_stance_counter - 1)
      end

      if (combatant.magic_stun_counter == 0 && combatant.magic_stun)
        FS3Combat.emit_to_combat combatant.combat, t('fs3combat.stun_wore_off', :name => combatant.name), nil, true
        combatant.update(magic_stun: false)
        combatant.update(magic_stun_spell: nil)
        combatant.log "#{combatant.name} is no longer magically stunned."
      elsif (combatant.magic_stun_counter > 0 && combatant.magic_stun)
        subduer = combatant.subdued_by
        FS3Combat.emit_to_combat combatant.combat, t('fs3combat.still_stunned', :name => combatant.name, :stunned_by => subduer.name, :rounds => combatant.magic_stun_counter), nil, true
        combatant.update(magic_stun_counter: combatant.magic_stun_counter - 1)
      end

      if combatant.magic_lethal_mod_counter == 0 && combatant.magic_lethal_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('magic.mod_wore_off', :name => combatant.name, :type => "lethality", :mod => combatant.magic_lethal_mod), nil, true
        combatant.update(magic_lethal_mod: 0)
        combatant.log "#{combatant.name} resetting lethality mod to #{combatant.magic_lethal_mod}."
      else
        combatant.update(magic_lethal_mod_counter: combatant.magic_lethal_mod_counter - 1)
      end

      if combatant.magic_defense_mod_counter == 0 && combatant.magic_defense_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('magic.mod_wore_off', :name => combatant.name, :type => "defense", :mod => combatant.magic_defense_mod), nil, true
        combatant.update(magic_defense_mod: 0)
        combatant.log "#{combatant.name} resetting defense mod to #{combatant.magic_defense_mod}."
      else
        combatant.update(magic_defense_mod_counter: combatant.magic_defense_mod_counter - 1)
      end

      if combatant.magic_attack_mod_counter == 0 && combatant.magic_attack_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('magic.mod_wore_off', :name => combatant.name, :type => "attack", :mod => combatant.magic_attack_mod), nil, true
        combatant.update(magic_attack_mod: 0)
        combatant.log "#{combatant.name} resetting attack mod to #{combatant.magic_attack_mod}."
      else
        combatant.update(magic_attack_mod_counter: combatant.magic_attack_mod_counter - 1)
      end

      if combatant.spell_mod_counter == 0 && combatant.spell_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('magic.mod_wore_off', :name => combatant.name, :type => "spell", :mod => combatant.spell_mod), nil, true
        combatant.update(spell_mod: 0)
        combatant.log "#{combatant.name} resetting spell mod to #{combatant.spell_mod}."
      else
        combatant.update(spell_mod_counter: combatant.spell_mod_counter - 1)
      end

      if !combatant.is_npc? && combatant.associated_model.auto_revive? && combatant.is_ko
        auto_revive_spell = combatant.associated_model.auto_revive?
        combatant.update(action_klass: "AresMUSH::FS3Combat::SpellAction")
        combatant.update(action_args: "#{auto_revive_spell}/#{combatant.name}")
        FS3Combat.emit_to_combat combatant.combat,t('magic.spell_action_msg_long', :name => combatant.name, :spell => auto_revive_spell), nil, true
      end

    end




  end
end
