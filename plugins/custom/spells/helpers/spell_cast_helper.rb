module AresMUSH
  module Custom

    def self.spell_weapon_effects(combatant, spell)
      rounds = Global.read_config("spells", spell, "rounds")
      special = Global.read_config("spells", spell, "weapon_specials")
      weapon = combatant.weapon.before("+")
      weapon_specials = combatant.spell_weapon_effects


      if combatant.spell_weapon_effects.has_key?(weapon)
        old_weapon_specials = weapon_specials[weapon]
        weapon_specials[weapon] = old_weapon_specials.merge!( special => rounds)
      else
        weapon_specials[weapon] = {special => rounds}
      end
      combatant.update(spell_weapon_effects:weapon_specials)

    end

    def self.spell_armor_effects(combatant, spell)
      rounds = Global.read_config("spells", spell, "rounds")
      special = Global.read_config("spells", spell, "armor_specials")
      weapon = combatant.armor.before("+")
      weapon_specials = combatant.spell_armor_effects



      if combatant.spell_armor_effects.has_key?(armor)
        old_armor_specials = armor_specials[armor]
        armor_specials[armor] = old_armor_specials.merge!( special => rounds)
      else
        armor_specials[armor] = {special => rounds}
      end
      combatant.update(spell_armor_effects:armor_specials)

    end


    def self.cast_noncombat_spell(caster, name_string, spell, mod)
      success = "%xgSUCCEEDS%xn"
      target_num = Global.read_config("spells", spell, "target_num")
      effect = Global.read_config("spells", spell, "effect")
      client = Login.find_client(caster)
      if name_string != nil
        targets = Custom.parse_spell_targets(name_string, target_num)
      else
        targets = "None"
      end

      if targets == t('custom.too_many_targets')
        client.emit_failure t('custom.too_many_targets', :spell => spell, :num => target_num)
      elsif targets == "no_target"
        client.emit_failure "%xrThat is not a character.%xn"
      elsif targets == "None"
        message = t('custom.casts_noncombat_spell', :name => caster.name, :spell => spell, :mod => mod, :succeeds => success)
      else
        names = []
        targets.each do |target|
          Global.logger.debug "Target: #{target.name} #{target.mind_shield}"
          if (effect == "Psionic" && target.mind_shield > 0)
            held = Custom.roll_mind_shield(target, caster) == "shield"
            Global.logger.debug "HELD: #{held}"
            if held
              message = t('custom.mind_shield_held', :name => caster.name, :spell => spell, :target => target.name)
              Global.logger.debug message
            else
              message = t('custom.mind_shield_failed', :name => caster.name, :spell => spell, :target => target.name)
              Global.logger.debug message
            end
          else
            names.concat [target.name]
          end
        end
        print_names = names.join(", ")
        msg = t('custom.casts_noncombat_spell_with_target', :name => caster.name, :target => print_names, :spell => spell, :mod => mod, :succeeds => success)
      end
      if message
        caster.room.emit message
        if caster.room.scene
          Scenes.add_to_scene(caster.room.scene, message)
        end
      elsif print_names
        caster.room.emit msg
        if caster.room.scene
          Scenes.add_to_scene(caster.room.scene, msg)
        end
      end
    end

    def self.parse_spell_targets(name_string, target_num)
      return t('fs3combat.no_targets_specified') if (!name_string)
      target_names = name_string.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
      targets = []
      target_names.each do |name|
        target = Character.named(name)
        return "no_target" if !target
        targets << target
      end
      targets = targets
      if (targets.count > target_num)
        return t('custom.too_many_targets')
      else
        return targets
      end
    end

    def self.cast_non_combat_heal(caster, name_string, spell, mod)
      room = caster.room
      target_num = Global.read_config("spells", spell, "target_num")
      heal_points = Global.read_config("spells", spell, "heal_points")

      if name_string != nil
        targets = Custom.parse_spell_targets(name_string, target_num)
      else
        targets = "None"
      end

      if targets == t('custom.too_many_targets')
        caster.client.emit_failure t('custom.too_many_targets', :spell => spell, :num => target_num)
      elsif targets == "no_target"
        caster.client.emit_failure "%xrThat is not a character.%xn"
      elsif targets == "None"
        target = caster
      end

      targets.each do |target|
        wound = FS3Combat.worst_treatable_wound(target)
        if (wound)
          FS3Combat.heal(wound, heal_points)
          message = t('custom.cast_heal', :name => caster.name, :spell => spell, :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :points => heal_points)
        else
          message = t('custom.cast_heal_no_effect', :name => caster.name, :spell => spell, :succeeds => "%xgSUCCEEDS%xn", :target => target.name)
        end
        room.emit message
        if room.scene
          Scenes.add_to_scene(room.scene, message)
        end
      end
    end

    def self.cast_noncombat_mind_shield(caster, target)
      shield_strength = caster.roll_ability("Spirit")
      Global.logger.info "Mind Shield Strength on #{target.name} set to #{shield_strength[:successes]}."
      target.update(mind_shield: shield_strength[:successes])

      message = t('custom.cast_mindshield', :name => caster.name, :spell => "Mind Shield", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name)
      room = caster.room
      room.emit message
      if room.scene
        Scenes.add_to_scene(room.scene, message)
      end
    end

    def self.roll_mind_shield(target, caster)
      shield_strength = target.mind_shield
      if caster.combat
        successes = caster.roll_ability("Spirit")
      else
        successes = caster.roll_ability("Spirit")[:successes]
      end
      delta = shield_strength - successes
      if caster.combat
        combat = caster.combat
        combat.log "#{caster.name} rolling Spirit vs #{target.name}'s Mind Shield (strength #{shield_strength}): #{successes} successes."
      end

      if (shield_strength <=0 && successes <= 0)
        return "shield"
      end

      case delta
      when 0..99
        return "shield"
      when -99..-1
        return "caster"
      end
    end

  end
end
