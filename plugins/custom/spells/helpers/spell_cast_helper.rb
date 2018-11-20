module AresMUSH
  module Custom

    def self.spell_weapon_effects(combatant, spell)
      rounds = Global.read_config("spells", spell, "rounds")
      special = Global.read_config("spells", spell, "weapon_specials")
      weapon = combatant.weapon.before("+")
      weapon_specials = combatant.spell_weapon_effects
      Global.logger.info "Combatant's old weapon effects: #{combatant.spell_weapon_effects}"

      if combatant.spell_weapon_effects.has_key?(weapon)
        old_weapon_specials = weapon_specials[weapon]
        weapon_specials[weapon] = old_weapon_specials.merge!( special => rounds)
      else
        weapon_specials[weapon] = {special => rounds}
      end


      combatant.update(spell_weapon_effects: weapon_specials)
      Global.logger.info "Combatant's weapon effects: #{combatant.spell_weapon_effects}"

    end

    # def self.cast_equip_armor(enactor, caster_combat, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   armor = Global.read_config("spells", spell, "armor")
    #   client = Login.find_client(caster_combat)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #     FS3Combat.set_armor(enactor, caster_combat, armor)
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #   end
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end
    #
    # def self.cast_equip_armor_specials(enactor, caster_combat, spell)
    #   armor_specials_str = Global.read_config("spells", spell, "armor_specials")
    #   armor_specials = armor_specials_str ? armor_specials_str.split('+') : nil
    #   client = Login.find_client(caster_combat)
    #   FS3Combat.set_armor(enactor, caster_combat, caster_combat.armor, armor_specials)
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end
    #
    # def self.cast_equip_weapon_specials(enactor, caster_combat, spell)
    #   weapon_specials_str = Global.read_config("spells", spell, "weapon_specials")
    #   weapon_specials = weapon_specials_str ? weapon_specials_str.split('+') : nil
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   client = Login.find_client(caster_combat)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #     FS3Combat.set_weapon(enactor, caster_combat, caster_combat.weapon, weapon_specials)
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #   end
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end
    #
    # def self.cast_equip_weapon(enactor, caster_combat, spell)
    #   weapon = Global.read_config("spells", spell, "weapon")
    #   FS3Combat.set_weapon(enactor, caster_combat, weapon)
    #   weapon_type = FS3Combat.weapon_stat(caster_combat.weapon, "weapon_type")
    #   armor = Global.read_config("spells", spell, "armor")
    #   is_stun = Global.read_config("spells", spell, "is_stun")
    #   if armor
    #
    #   elsif is_stun
    #
    #   elsif weapon_type == "Explosive"
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.will_cast_spell', :name => caster_combat.name, :spell => spell), nil, true
    #     FS3Combat.emit_to_combatant enactor.combatant, t('custom.target_aoe')
    #   elsif weapon_type == "Supressive"
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.will_cast_spell', :name => caster_combat.name, :spell => spell), nil, true
    #     FS3Combat.emit_to_combatant enactor.combatant, t('custom.target_suppress')
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.will_cast_spell', :name => caster_combat.name, :spell => spell), nil, true
    #     FS3Combat.emit_to_combatant enactor.combatant, t('custom.target_attack')
    #   end
    # end


    # def self.cast_roll_spell(caster_combat, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   client = Login.find_client(caster_combat)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #   end
    #   FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")
    # end

    def self.cast_noncombat_spell(caster, spell, mod)
      enactor_room = caster.room
      success = Custom.roll_noncombat_spell_success(caster, spell, mod)
      message = t('custom.casts_noncombat_spell', :name => caster.name, :spell => spell, :succeeds => success)
      enactor_room.emit message
      if enactor_room.scene
        Scenes.add_to_scene(enactor_room.scene, message)
      end
    end

    # def self.cast_heal(caster_combat, caster, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     wound = FS3Combat.worst_treatable_wound(caster)
    #     heal_points = Global.read_config("spells", spell, "heal_points")
    #     if (wound)
    #       FS3Combat.heal(wound, heal_points)
    #       FS3Combat.emit_to_combat caster.combat, t('custom.cast_heal', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => caster.name, :points => heal_points), nil, true
    #     else
    #       FS3Combat.emit_to_combat caster.combat, t('custom.cast_heal_no_effect', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => caster.name), nil, true
    #     end
    #   else
    #     FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds), nil, true
    #   end
    # end

    def self.cast_non_combat_heal(caster, spell, mod)
      succeeds = Custom.roll_noncombat_spell_success(caster, spell, mod)
      client = Login.find_client(caster)
      if succeeds == "%xgSUCCEEDS%xn"
        wound = FS3Combat.worst_treatable_wound(caster)
        heal_points = Global.read_config("spells", spell, "heal_points")
        if (wound)
          FS3Combat.heal(wound, heal_points)
          message = t('custom.cast_heal', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => caster.name, :points => heal_points)
          client.emit message
          if caster.room.scene
            Scenes.add_to_scene(caster.room.scene, message)
          end
        else
          message = t('custom.cast_heal_no_effect', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => caster.name)
          client.emit message
          if caster.room.scene
            Scenes.add_to_scene(caster.room.scene, message)
          end
        end
      else
        message = t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
        client.emit message
        if caster.room.scene
          Scenes.add_to_scene(caster.room.scene, message)
        end
      end
    end

    # def self.cast_stun_spell(enactor, caster_combat, spell)
    #   client = Login.find_client(caster_combat)
    #   FS3Combat.emit_to_combat caster_combat.combat, t('custom.will_cast_spell', :name => caster_combat.name, :spell => spell), nil, true
    #   FS3Combat.emit_to_combatant enactor.combatant, t('custom.target_stun')
    # end
    #
    # def self.cast_stance(caster_combat, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     stance = Global.read_config("spells", spell, "stance")
    #     caster_combat.update(stance: stance)
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_stance', :name => caster_combat.name, :target => caster_combat.name, :spell => spell, :succeeds => succeeds, :stance => stance), nil, true
    #   else
    #     FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
    #   end
    # end
    #
    # def self.cast_lethal_mod(caster_combat, spell)
    #   succeeds = "%xgSUCCEEDS%xn"
    #   lethal_mod = Global.read_config("spells", spell, "lethal_mod")
    #   current_mod = caster_combat.damage_lethality_mod
    #   new_mod = current_mod + lethal_mod
    #   caster_combat.update(damage_lethality_mod: new_mod)
    #   FS3Combat.emit_to_combat caster_combat.combat, t('cast_mod', :name => caster_combat.name, :spell => spell, :succeeds => succeeds, :target => "themself", :mod => lethal_mod, :type => "lethality", :total_mod => caster_combat.damage_lethality_mod), nil, true
    # end
    #
    # def self.cast_defense_mod(caster_combat, spell)
    #   succeeds = "%xgSUCCEEDS%xn"
    #   defense_mod = Global.read_config("spells", spell, "defense_mod")
    #   current_mod = caster_combat.defense_mod
    #   new_mod = current_mod + defense_mod
    #   caster_combat.update(defense_mod: new_mod)
    #   FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_mod', :name => caster_combat.name, :target => "themself", :spell => spell, :succeeds => succeeds, :mod => defense_mod, :type => "defense", :total_mod => caster_combat.defense_mod), nil, true
    # end
    #
    # def self.cast_spell_mod(caster_combat, spell)
    #   succeeds = "%xgSUCCEEDS%xn"
    #   spell_mod = Global.read_config("spells", spell, "spell_mod")
    #   current_mod = caster_combat.spell_mod.to_i
    #   new_mod = current_mod + spell_mod
    #   caster_combat.update(spell_mod: new_mod)
    #   FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_mod', :name => caster_combat.name, :target => "themself", :spell => spell, :succeeds => succeeds, :mod => spell_mod, :type => "spell", :total_mod => caster_combat.spell_mod), nil, true
    # end
    #
    # def self.cast_attack_mod(caster_combat, spell)
    #   succeeds = "%xgSUCCEEDS%xn"
    #   attack_mod = Global.read_config("spells", spell, "attack_mod")
    #   current_mod = caster_combat.attack_mod
    #   new_mod = current_mod + attack_mod
    #   caster_combat.update(attack_mod: new_mod)
    #   FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_mod', :name => caster_combat.name, :target => "themself", :spell => spell, :succeeds => succeeds, :mod => attack_mod, :type => "attack", :total_mod => caster_combat.attack_mod), nil, true
    # end


  end
end
