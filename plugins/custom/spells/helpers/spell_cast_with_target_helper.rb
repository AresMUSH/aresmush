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

        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell)
        FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end

    def self.cast_revive(caster, target, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      if succeeds == "%xgSUCCEEDS%xn"

        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell)
        FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end

    def self.cast_lethal_mod(caster, target, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      if succeeds == "%xgSUCCEEDS%xn"

        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell)
        FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end

    def self.cast_defense_mod(caster, target, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      if succeeds == "%xgSUCCEEDS%xn"

        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell)
        FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end

    def self.cast_attack_mod(caster, target, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      if succeeds == "%xgSUCCEEDS%xn"

        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell)
        FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end

    def self.cast_spell_mod(caster, target, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      if succeeds == "%xgSUCCEEDS%xn"

        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell)
        FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end

    def self.cast_stance(caster, target, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      if succeeds == "%xgSUCCEEDS%xn"

        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell)
        FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end


  end
end
