module AresMUSH
  module Spells

    def self.cast_equip_armor(caster, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      armor = Global.read_config("spells", spell, "armor")
      client = Login.find_client(caster)
      if succeeds == "%xgSUCCEEDS%xn"
        caster.combatant.update(armor_name: armor)
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
      FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
    end

    def self.cast_equip_armor_specials(caster, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      armor_specials = Global.read_config("spells", spell, "armor_specials")
      client = Login.find_client(caster)
      if succeeds == "%xgSUCCEEDS%xn"
        caster.combatant.update(armor_specials: armor_specials)
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell)
        FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end

    def self.cast_equip_weapon(caster, spell)
      weapon = Global.read_config("spells", spell, "weapon")
      client = Login.find_client(caster)
      caster.combatant.update(weapon_name: weapon)
        weapon_type = FS3Combat.weapon_stat(caster.combatant.weapon, "weapon_type")
      armor = Global.read_config("spells", spell, "armor")
      is_stun = Global.read_config("spells", spell, "is_stun")
      if armor

      elsif is_stun

      elsif weapon_type == "Explosive"
        FS3Combat.emit_to_combat caster.combat, t('custom.will_cast_spell', :name => caster.name, :spell => spell)
        FS3Combat.emit_to_combatant caster.combatant, t('custom.target_aoe')
      elsif weapon_type == "Supressive"
        FS3Combat.emit_to_combat caster.combat, t('custom.will_cast_spell', :name => caster.name, :spell => spell)
        FS3Combat.emit_to_combatant caster.combatant, t('custom.target_suppress')
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.will_cast_spell', :name => caster.name, :spell => spell)
        FS3Combat.emit_to_combatant caster.combatant, t('custom.target_attack')
      end
    end

    def self.equip_weapon_specials(caster, spell)
      weapon_specials = Global.read_config("spells", spell, "weapon_specials")
      succeeds = Custom.roll_spell_success(caster, spell)
      client = Login.find_client(caster)
      if succeeds == "%xgSUCCEEDS%xn"
        caster.combatant.update(weapon_specials: weapon_specials ? weapon_specials.map { |s| s.titlecase } : [])
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell)
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
      FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
    end

    def self.cast_roll_spell(caster, spell)
      succeeds = Custom.roll_spell_success(caster, spell)
      client = Login.find_client(caster)
      if succeeds == "%xgSUCCEEDS%xn"
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
      FS3Combat.set_action(client, caster, caster.combat, caster.combatant, FS3Combat::SpellAction, "")
    end

    def self.cast_stun_spell(caster, spell)
      client = Login.find_client(caster)
      FS3Combat.emit_to_combat caster.combat, t('custom.will_cast_spell', :name => caster.name, :spell => spell)
      FS3Combat.emit_to_combatant caster.combatant, t('custom.target_stun')
    end



  end
end
