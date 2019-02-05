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
      combatant.update(spell_weapon_effects:weapon_specials)
      Global.logger.info "Combatant's weapon effects: #{combatant.spell_weapon_effects}"
    end

    def self.spell_armor_effects(combatant, spell)
      rounds = Global.read_config("spells", spell, "rounds")
      special = Global.read_config("spells", spell, "armor_specials")
      weapon = combatant.armor.before("+")
      weapon_specials = combatant.spell_armor_effects

      Global.logger.info "Combatant's old armor effects: #{combatant.spell_armor_effects}"

      if combatant.spell_armor_effects.has_key?(armor)
        old_armor_specials = armor_specials[armor]
        armor_specials[armor] = old_armor_specials.merge!( special => rounds)
      else
        armor_specials[armor] = {special => rounds}
      end
      combatant.update(spell_armor_effects:armor_specials)
      Global.logger.info "Combatant's armor effects: #{combatant.spell_armor_effects}"
    end


    def self.cast_noncombat_spell(caster, spell, mod)
      enactor_room = caster.room
      success = Custom.roll_noncombat_spell_success(caster, spell, mod)
      message = t('custom.casts_noncombat_spell', :name => caster.name, :spell => spell, :mod => mod, :succeeds => success)
      enactor_room.emit message
      if enactor_room.scene
        Scenes.add_to_scene(enactor_room.scene, message)
      end
    end

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


  end
end
