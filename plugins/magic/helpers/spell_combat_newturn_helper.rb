module AresMUSH
  module Magic

    def self.spell_newturn(combatant)
      if (combatant.init_spell_mod_counter == 0 && combatant.init_spell_mod > 0)
        FS3Combat.emit_to_combat combatant.combat, t('custom.mod_wore_off', :name => combatant.name, :type => "initiative", :mod => combatant.init_spell_mod), nil, true
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
        FS3Combat.emit_to_combat combatant.combat, t('custom.stance_wore_off', :name => combatant.name, :spell => combatant.stance_spell, :stance => stance), nil, true
        combatant.log "#{combatant.name} #{combatant.stance_spell} wore off."
        combatant.update(stance_spell: nil)
        combatant.update(stance: "Normal")
      elsif (combatant.stance_counter > 0 && combatant.stance_spell)
        combatant.update(stance_counter: combatant.stance_counter - 1)
      end

      if (combatant.mind_shield_counter == 0 && combatant.mind_shield > 0)
        FS3Combat.emit_to_combat combatant.combat, t('custom.shield_wore_off', :name => combatant.name, :shield => "Mind Shield"), nil, true
        combatant.update(mind_shield: 0)
        combatant.log "#{combatant.name} no longer has a Mind Shield."
      elsif (combatant.mind_shield_counter > 0 && combatant.mind_shield > 0)
        combatant.update(mind_shield_counter: combatant.mind_shield_counter - 1)
      end

      if (combatant.endure_fire_counter == 0 && combatant.endure_fire > 0)
        FS3Combat.emit_to_combat combatant.combat, t('custom.shield_wore_off', :name => combatant.name, :shield => "Endure Fire"), nil, true
        combatant.update(endure_fire: 0)
        combatant.log "#{combatant.name} can no longer Endure Fire."
      elsif (combatant.endure_fire_counter > 0 && combatant.endure_fire > 0)
        combatant.update(endure_fire_counter: combatant.endure_fire_counter - 1)
      end

      if (combatant.endure_cold_counter == 0 && combatant.endure_cold > 0)
        FS3Combat.emit_to_combat combatant.combat, t('custom.shield_wore_off', :name => combatant.name, :shield => "Endure Cold"), nil, true
        combatant.update(endure_cold: 0)
        combatant.log "#{combatant.name} can no longer Endure Cold."
      elsif (combatant.endure_cold_counter > 0 && combatant.endure_cold > 0)
        combatant.update(endure_cold_counter: combatant.endure_cold_counter - 1)
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
        FS3Combat.emit_to_combat combatant.combat, t('custom.mod_wore_off', :name => combatant.name, :type => "lethality", :mod => combatant.spell_damage_lethality_mod), nil, true
        combatant.update(spell_damage_lethality_mod: 0)
        combatant.log "#{combatant.name} resetting lethality mod to #{combatant.spell_damage_lethality_mod}."
      else
        combatant.update(lethal_mod_counter: combatant.lethal_mod_counter - 1)
      end

      if combatant.defense_mod_counter == 0 && combatant.spell_defense_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('custom.mod_wore_off', :name => combatant.name, :type => "defense", :mod => combatant.spell_defense_mod), nil, true
        combatant.update(spell_defense_mod: 0)
        combatant.log "#{combatant.name} resetting defense mod to #{combatant.spell_defense_mod}."
      else
        combatant.update(defense_mod_counter: combatant.defense_mod_counter - 1)
      end

      if combatant.attack_mod_counter == 0 && combatant.spell_attack_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('custom.mod_wore_off', :name => combatant.name, :type => "attack", :mod => combatant.spell_attack_mod), nil, true
        combatant.update(spell_attack_mod: 0)
        combatant.log "#{combatant.name} resetting attack mod to #{combatant.spell_attack_mod}."
      else
        combatant.update(attack_mod_counter: combatant.attack_mod_counter - 1)
      end

      if combatant.spell_mod_counter == 0 && combatant.spell_mod != 0
        FS3Combat.emit_to_combat combatant.combat, t('custom.mod_wore_off', :name => combatant.name, :type => "spell", :mod => combatant.spell_mod), nil, true
        combatant.update(spell_mod: 0)
        combatant.log "#{combatant.name} resetting spell mod to #{combatant.spell_mod}."
      else
        combatant.update(spell_mod_counter: combatant.spell_mod_counter - 1)
      end
    end

  end
end
