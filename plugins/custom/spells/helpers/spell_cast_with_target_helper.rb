module AresMUSH
  module Custom

    # def self.cast_inflict_damage_with_target(caster_combat, target, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   damage_desc = Global.read_config("spells", spell, "damage_desc")
    #   damage_inflicted = Global.read_config("spells", spell, "damage_inflicted")
    #   client = Login.find_client(caster_combat)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     FS3Combat.inflict_damage(target, damage_inflicted, damage_desc)
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_damage', :name => caster_combat.name, :spell => spell, :succeeds => succeeds, :target => target.name, :damage_desc => spell.downcase), nil, true
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #   end
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end

    # def self.cast_roll_spell_with_target(caster_combat, target, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   client = Login.find_client(caster_combat)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell_on_target', :name => caster_combat.name, :spell => spell, :target => target.name, :succeeds => succeeds), nil, true
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #   end
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end

    def self.cast_noncombat_roll_spell_with_target(caster, target, spell)
      enactor_room = caster.room
      success = Custom.roll_noncombat_spell_success(caster, spell)
      enactor_room.emit t('custom.casts_noncombat_spell_with_target', :name => caster.name, :target => target.name, :spell => spell, :succeeds => success)
    end

    # def self.cast_heal_with_target(caster_combat, target, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     wound = FS3Combat.worst_treatable_wound(target)
    #     heal_points = Global.read_config("spells", spell, "heal_points")
    #     if (wound)
    #       FS3Combat.heal(wound, heal_points)
    #       FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_heal', :name => caster_combat.name, :spell => spell, :succeeds => succeeds, :target => target.name, :points => heal_points), nil, true
    #     else
    #       FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_heal_no_effect', :name => caster_combat.name, :spell => spell, :succeeds => succeeds, :target => target.name), nil, true
    #     end
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #   end
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end

    def self.cast_non_combat_heal_with_target(caster, target, spell)
      succeeds = Custom.roll_noncombat_spell_success(caster, spell)
      client = Login.find_client(caster)
      if succeeds == "%xgSUCCEEDS%xn"
        wound = FS3Combat.worst_treatable_wound(target)
        heal_points = Global.read_config("spells", spell, "heal_points")
        if (wound)
          FS3Combat.heal(wound, heal_points)
          client.emit t('custom.cast_heal', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name, :points => heal_points)
        else
          client.emit t('custom.cast_heal_no_effect', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name)
        end
      else
        client.emit t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end


    # def self.cast_revive(caster_combat, target_combat, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     target_combat.update(is_ko: false)
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_res', :name => caster_combat.name, :spell => spell, :succeeds => succeeds, :target => target_combat.name), nil, true
    #     FS3Combat.emit_to_combatant target_combat, t('custom.been_resed', :name => caster_combat.name), nil, true
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #   end
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end

    # def cast_res(caster, target, target_combat, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster, spell)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     Custom.undead(target)
    #     FS3Combat.emit_to_combat caster.combat, t('custom.cast_res', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name)
    #     FS3Combat.emit_to_combatant target_combat, t('custom.been_resed', :name => caster.name)
    #   else
    #     FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
    #   end
    # end

    # def self.cast_lethal_mod_with_target(caster_combat, target_combat, spell)
    #   succeeds = "%xgSUCCEEDS%xn"
    #   lethal_mod = Global.read_config("spells", spell, "lethal_mod")
    #   current_mod = target_combat.damage_lethality_mod
    #   new_mod = current_mod + lethal_mod
    #   target_combat.update(damage_lethality_mod: new_mod)
    #   FS3Combat.emit_to_combat caster_combat.combat, t('cast_mod', :name => caster_combat.name, :spell => spell, :succeeds => succeeds, :target =>  target_combat.name, :mod => lethal_mod, :type => "lethality", :total_mod => target_combat.damage_lethality_mod), nil, true
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end

    # def self.cast_defense_mod_with_target(caster_combat,  target_combat, spell)
    #   succeeds = "%xgSUCCEEDS%xn"
    #   defense_mod = Global.read_config("spells", spell, "defense_mod")
    #   current_mod =  target_combat.defense_mod
    #   new_mod = current_mod + defense_mod
    #   target_combat.update(defense_mod: new_mod)
    #   FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_mod', :name => caster_combat.name, :target => target_combat.name, :spell => spell, :succeeds => succeeds, :mod => defense_mod, :type => "defense", :total_mod => target_combat.defense_mod), nil, true
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end
    #
    # def self.cast_attack_mod_with_target(caster_combat, target_combat, spell)
    #   succeeds = "%xgSUCCEEDS%xn"
    #   attack_mod = Global.read_config("spells", spell, "attack_mod")
    #   current_mod = target_combat.attack_mod
    #   new_mod = current_mod + attack_mod
    #   target_combat.update(attack_mod: new_mod)
    #   FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_mod', :name => caster_combat.name, :target => target_combat.name, :spell => spell, :succeeds => succeeds, :mod => attack_mod, :type => "attack", :total_mod => target_combat.attack_mod), nil, true
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end
    #
    # def self.cast_spell_mod_with_target(caster_combat, target_combat, spell)
    #   succeeds = "%xgSUCCEEDS%xn"
    #   spell_mod = Global.read_config("spells", spell, "spell_mod")
    #   current_mod = target_combat.spell_mod.to_i
    #   new_mod = current_mod + spell_mod
    #   target_combat.update(spell_mod: new_mod)
    #   FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_mod', :name => caster_combat.name, :target => target_combat.name, :spell => spell, :succeeds => succeeds, :mod => spell_mod, :type => "spell", :total_mod => target_combat.spell_mod), nil, true
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end

    # def self.cast_stance_with_target(caster_combat, target_combat, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     stance = Global.read_config("spells", spell, "stance")
    #     target_combat.update(stance: stance)
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_stance', :name => caster_combat.name, :target => target_combat.name, :spell => spell, :succeeds => succeeds, :stance => stance), nil, true
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #   end
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end

    # def self.cast_equip_weapon_with_target(enactor, caster_combat, target_combat, spell)
    #   weapon = Global.read_config("spells", spell, "weapon")
    #   armor = Global.read_config("spells", spell, "armor")
    #   if armor
    #
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => "%xgSUCCEEDS%xn"), nil, true
    #   end
    #   FS3Combat.set_weapon(enactor, target_combat, weapon)
    #
    # end

    # def self.cast_equip_weapon_specials_with_target(enactor, caster_combat, target_combat, spell)
    #   weapon_specials_str = Global.read_config("spells", spell, "weapon_specials")
    #   weapon_specials = weapon_specials_str ? weapon_specials_str.split('+') : nil
    #   FS3Combat.set_weapon(enactor, target_combat, target_combat.weapon, weapon_specials)
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end

    # def self.cast_equip_armor_with_target(enactor, caster_combat, target_combat, spell)
    #   FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => "%xgSUCCEEDS%xn"), nil, true
    #   armor = Global.read_config("spells", spell, "armor")
    #   FS3Combat.set_armor(enactor, target_combat, armor)
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end


    # def self.cast_equip_armor_specials_with_target(enactor, caster_combat, target_combat, spell)
    #   armor_specials_str = Global.read_config("spells", spell, "armor_specials")
    #   armor_specials = armor_specials_str ? armor_specials_str.split('+') : nil
    #   FS3Combat.set_armor(enactor, target_combat, target_combat.armor, armor_specials)
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end

  end
end
