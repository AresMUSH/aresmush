module AresMUSH
  module Custom

    def self.potion_inflict_damage_with_target(caster, target, spell)
      damage_desc = Global.read_config("spells", spell, "damage_desc")
      damage_inflicted = Global.read_config("spells", spell, "damage_inflicted")
      return t('custom.cant_heal_dead') if (target.dead)
      FS3Combat.inflict_damage(target, damage_inflicted, damage_desc)
      FS3Combat.emit_to_combat caster.combat, t('custom.potion_damage', :name => caster.name, :potion => spell, :target => target.name)
    end

    def self.potion_heal_with_target(caster, target, spell)
      wound = FS3Combat.worst_treatable_wound(target)
      heal_points = Global.read_config("spells", spell, "heal_points")
      if (wound)
        FS3Combat.heal(wound, heal_points)
        FS3Combat.emit_to_combat caster.combat, t('custom.potion_heal_with_target', :name => caster.name, :potion => spell, :target => target.name, :points => heal_points)
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.potion_heal_no_effect_with_target', :name => caster.name, :potion => spell, :target => target.name)
      end
    end

    def self.potion_non_combat_heal_with_target(caster, target, spell)
      client = Login.find_client(caster)
      wound = FS3Combat.worst_treatable_wound(target)
      heal_points = Global.read_config("spells", spell, "heal_points")
      if (wound)
        FS3Combat.heal(wound, heal_points)
        client.emit t('custom.potion_heal_with_target', :name => caster.name, :potion => spell, :target => target.name, :points => heal_points)
      else
        client.emit t('custom.potion_heal_no_effect_with_target', :name => caster.name, :potion => spell, :target => target.name)
      end
    end

    def self.potion_revive(caster_combat, target_combat, spell)
      target_combat.update(is_ko: false)
      FS3Combat.emit_to_combat caster_combat.combat, t('custom.potion_res', :name => caster_combat.name, :potion => spell, :target => target_combat.name)
      FS3Combat.emit_to_combatant target_combat, t('custom.been_resed', :name => caster_combat.name)
    end

    # def self.cast_revive(caster, target, target_combat, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster, spell)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     Custom.undead(target)
    #     FS3Combat.emit_to_combat caster.combat, t('custom.cast_res', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name)
    #     FS3Combat.emit_to_combatant target_combat, t('custom.been_resed', :name => caster.name)
    #   else
    #     FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :potion => spell, :succeeds => succeeds)
    #   end
    # end

    def self.potion_lethal_mod_with_target(caster, target_combat, spell)
      lethal_mod = Global.read_config("spells", spell, "lethal_mod")
      current_mod = target_combat.damage_lethality_mod
      new_mod = current_mod + lethal_mod
      target_combat.update(damage_lethality_mod: new_mod)
      FS3Combat.emit_to_combat caster.combat, t('potion_mod_with_target', :name => caster.name, :potion => spell, :target =>  target_combat.name, :mod => lethal_mod, :type => "lethality", :total_mod => target_combat.damage_lethality_mod)
    end

    def self.potion_defense_mod_with_target(caster,  target_combat, spell)
      defense_mod = Global.read_config("spells", spell, "defense_mod")
      current_mod =  target_combat.defense_mod
      new_mod = current_mod + defense_mod
      target_combat.update(defense_mod: new_mod)
      FS3Combat.emit_to_combat caster.combat, t('custom.potion_mod_with_target', :name => caster.name, :target => target_combat.name, :potion => spell, :mod => defense_mod, :type => "defense", :total_mod => target_combat.defense_mod)
    end

    def self.potion_attack_mod_with_target(caster, target_combat, spell)
      attack_mod = Global.read_config("spells", spell, "attack_mod")
      current_mod = target_combat.attack_mod
      new_mod = current_mod + attack_mod
      target_combat.update(attack_mod: new_mod)
      FS3Combat.emit_to_combat caster.combat, t('custom.potion_mod_with_target', :name => caster.name, :target => target_combat.name, :potion => spell, :mod => attack_mod, :type => "attack", :total_mod => target_combat.attack_mod)
    end

    def self.potion_spell_mod_with_target(caster, target_combat, spell)
      spell_mod = Global.read_config("spells", spell, "spell_mod")
      current_mod = target_combat.spell_mod.to_i
      new_mod = current_mod + spell_mod
      target_combat.update(spell_mod: new_mod)
      FS3Combat.emit_to_combat caster.combat, t('custom.potion_mod_with_target', :name => caster.name, :target => target_combat.name, :potion => spell, :mod => spell_mod, :type => "spell", :total_mod => target_combat.spell_mod)
    end

    def self.potion_stance_with_target(caster, target_combat, spell)
      stance = Global.read_config("spells", spell, "stance")
      target_combat.update(stance: stance)
      FS3Combat.emit_to_combat caster.combat, t('custom.potion_stance_with_target', :name => caster.name, :target => target_combat.name, :potion => spell, :stance => stance)
    end

    def self.potion_equip_weapon_with_target(enactor, caster_combat, target_combat, spell)
      weapon = Global.read_config("spells", spell, "weapon")
      armor = Global.read_config("spells", spell, "armor")
      if armor

      else
        FS3Combat.emit_to_combat caster_combat.combat, t('custom.use_potion_with_target', :name => caster_combat.name, :potion => spell, :target => target_combat.name)
      end

      FS3Combat.set_weapon(enactor, target_combat, weapon)

    end

    def self.potion_equip_weapon_specials_with_target(enactor, caster_combat, target_combat, spell)
      weapon_specials_str = Global.read_config("spells", spell, "weapon_specials")
      weapon_specials = weapon_specials_str ? weapon_specials_str.split('+') : nil
      FS3Combat.set_weapon(enactor, target_combat, target_combat.weapon, weapon_specials)

    end

    def self.potion_equip_armor_with_target(enactor, caster_combat, target_combat, spell)
      FS3Combat.emit_to_combat caster_combat.combat, t('custom.use_potion_with_target', :name => caster_combat.name, :potion => spell, :target => target_combat.name)
      armor = Global.read_config("spells", spell, "armor")
      FS3Combat.set_armor(enactor, target_combat, armor)
    end


    def self.potion_equip_armor_specials_with_target(enactor, caster_combat, target_combat, spell)
      armor_specials_str = Global.read_config("spells", spell, "armor_specials")
      armor_specials = armor_specials_str ? armor_specials_str.split('+') : nil
      FS3Combat.set_armor(enactor, target_combat, target_combat.armor, armor_specials)
    end

  end
end
