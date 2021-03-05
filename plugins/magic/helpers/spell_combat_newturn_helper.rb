module AresMUSH
  module Magic

    def self.spell_newturn(combatant)

      Magic.shield_newturn_countdown(combatant)

      if (combatant.init_spell_mod_counter == 0 && combatant.init_spell_mod > 0)
        FS3Combat.emit_to_combat combatant.combat, t('magic.mod_wore_off', :name => combatant.name, :type => "initiative", :mod => combatant.init_spell_mod), nil, true
        combatant.update(init_spell_mod: 0)
        combatant.log "#{combatant.name} resetting initiative mod to #{combatant.damage_lethality_mod}."
      elsif (combatant.init_spell_mod_counter > 0 && combatant.init_spell_mod > 0)
        combatant.update(init_spell_mod_counter: combatant.init_spell_mod_counter - 1)
      end

      if (combatant.stance_counter == 0 && combatant.stance_spell)
        stance = Global.read_config("spells", combatant.stance_spell, "stance")
        if stance == "cover"
          stance = "in cover"
        end
        FS3Combat.emit_to_combat combatant.combat, t('magic.stance_wore_off', :name => combatant.name, :spell => combatant.stance_spell, :stance => stance), nil, true
        combatant.log "#{combatant.name} #{combatant.stance_spell} wore off."
        combatant.update(stance_spell: nil)
        combatant.update(stance: "Normal")
      elsif (combatant.stance_counter > 0 && combatant.stance_spell)
        combatant.update(stance_counter: combatant.stance_counter - 1)
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

      if combatant.lethal_mod_counter == 0 && combatant.spell_damage_lethality_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('magic.mod_wore_off', :name => combatant.name, :type => "lethality", :mod => combatant.spell_damage_lethality_mod), nil, true
        combatant.update(spell_damage_lethality_mod: 0)
        combatant.log "#{combatant.name} resetting lethality mod to #{combatant.spell_damage_lethality_mod}."
      else
        combatant.update(lethal_mod_counter: combatant.lethal_mod_counter - 1)
      end

      if combatant.defense_mod_counter == 0 && combatant.spell_defense_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('magic.mod_wore_off', :name => combatant.name, :type => "defense", :mod => combatant.spell_defense_mod), nil, true
        combatant.update(spell_defense_mod: 0)
        combatant.log "#{combatant.name} resetting defense mod to #{combatant.spell_defense_mod}."
      else
        combatant.update(defense_mod_counter: combatant.defense_mod_counter - 1)
      end

      if combatant.attack_mod_counter == 0 && combatant.spell_attack_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('magic.mod_wore_off', :name => combatant.name, :type => "attack", :mod => combatant.spell_attack_mod), nil, true
        combatant.update(spell_attack_mod: 0)
        combatant.log "#{combatant.name} resetting attack mod to #{combatant.spell_attack_mod}."
      else
        combatant.update(attack_mod_counter: combatant.attack_mod_counter - 1)
      end

      if combatant.spell_mod_counter == 0 && combatant.spell_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('magic.mod_wore_off', :name => combatant.name, :type => "spell", :mod => combatant.spell_mod), nil, true
        combatant.update(spell_mod: 0)
        combatant.log "#{combatant.name} resetting spell mod to #{combatant.spell_mod}."
      else
        combatant.update(spell_mod_counter: combatant.spell_mod_counter - 1)
      end

      if !combatant.is_npc? && combatant.associated_model.auto_revive? && combatant.is_ko
        puts " Auto rev spell: #{combatant.associated_model.auto_revive?}"
        auto_revive_spell = combatant.associated_model.auto_revive?
        # combatant.update(is_ko: false)
        # Magic.delete_all_unhealed_damage(combatant.associated_model)
        combatant.update(action_klass: "AresMUSH::FS3Combat::SpellAction")
        combatant.update(action_args: "#{auto_revive_spell}/#{combatant.name}")
        FS3Combat.emit_to_combat combatant.combat,t('magic.spell_action_msg_long', :name => combatant.name, :spell => auto_revive_spell), nil, true
        # EMIT SOMETHING
      end

    end




  end
end
