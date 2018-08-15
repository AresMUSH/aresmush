module AresMUSH
  module Custom

    def self.cast_inflict_damage(caster, target, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      damage_desc = Global.read_config("spells", spell, "damage_desc")
      damage_inflicted = Global.read_config("spells", spell, "damage_inflicted")
      if succeeds == "%xgSUCCEEDS%xn"
        FS3Combat.inflict_damage(target, damage_inflicted, damage_desc)
        FS3Combat.emit_to_combat caster.combat, t('custom.cast_damage', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name, :damage_desc => spell.downcase)
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end

    def self.cast_heal(caster, target, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      if succeeds == "%xgSUCCEEDS%xn"
        wound = FS3Combat.worst_treatable_wound(target)
        heal_points = Global.read_config("spells", spell, "heal_points")
        if (wound)
          FS3Combat.heal(wound, heal_points)
          FS3Combat.emit_to_combat caster.combat, t('custom.cast_heal', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name, :points => heal_points)
        else
          FS3Combat.emit_to_combat caster.combat, t('custom.cast_heal_no_effect', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name)
        end
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end

    def self.cast_revive(caster, target, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      if succeeds == "%xgSUCCEEDS%xn"
        target.combatant.update(is_ko: false)
        FS3Combat.emit_to_combat caster.combat, t('custom.cast_revive', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name)
        target.combatant.update(has_cast: true)
        FS3Combat.emit_to_combatant target.combatant, t('custom.been_revived', :name => caster.name)
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end

    def self.cast_lethal_mod(caster, target, spell)
      succeeds = "%xgSUCCEEDS%xn"
      lethal_mod = Global.read_config("spells", spell, "lethal_mod")
      current_mod = target.combatant.damage_lethality_mod
      new_mod = current_mod + lethal_mod
      target.combatant.update(damage_lethality_mod: new_mod)
      FS3Combat.emit_to_combat caster.combat, t('cast_mod', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target, :mod => lethal_mod, :type => "lethality", :total_mod => target.combatant.damage_lethality_mod)
    end

    def self.cast_defense_mod(caster, target, spell)
      succeeds = "%xgSUCCEEDS%xn"
      defense_mod = Global.read_config("spells", spell, "defense_mod")
      current_mod = target.combatant.defense_mod
      new_mod = current_mod + defense_mod
      target.combatant.update(defense_mod: new_mod)
      FS3Combat.emit_to_combat caster.combat, t('custom.cast_mod', :name => caster.name, :target => target.name, :spell => spell, :succeeds => succeeds, :mod => defense_mod, :type => "defense", :total_mod => target.combatant.defense_mod)
    end

    def self.cast_attack_mod(caster, target, spell)
      succeeds = "%xgSUCCEEDS%xn"
      attack_mod = Global.read_config("spells", spell, "attack_mod")
      current_mod = target.combatant.attack_mod
      new_mod = current_mod + attack_mod
      target.combatant.update(attack_mod: new_mod)
      FS3Combat.emit_to_combat caster.combat, t('custom.cast_mod', :name => caster.name, :target => target.name, :spell => spell, :succeeds => succeeds, :mod => attack_mod, :type => "attack", :total_mod => target.combatant.attack_mod)
    end

    def self.cast_spell_mod(caster, target, spell)
      succeeds = "%xgSUCCEEDS%xn"
      spell_mod = Global.read_config("spells", spell, "spell_mod")
      current_mod = target.combatant.spell_mod.to_i
      new_mod = current_mod + spell_mod
      target.combatant.update(spell_mod: new_mod)
      FS3Combat.emit_to_combat caster.combat, t('custom.cast_mod', :name => caster.name, :target => target.name, :spell => spell, :succeeds => succeeds, :mod => spell_mod, :type => "spell", :total_mod => target.combatant.spell_mod)
    end

    def self.cast_stance(caster, target, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      if succeeds == "%xgSUCCEEDS%xn"

        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell)
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end


  end
end
