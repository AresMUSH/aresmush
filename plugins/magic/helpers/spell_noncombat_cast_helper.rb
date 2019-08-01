module AresMUSH
  module Magic

    def self.roll_noncombat_spell_success(caster, spell, mod = nil)
      if Magic.knows_spell?(caster, spell)
        school = Global.read_config("spells", spell, "school")
      else
        school = "Magic"
        cast_mod = FS3Skills.ability_rating(caster, "Magic") * 2
        mod = mod.to_i + cast_mod
      end

      spell_mod = Magic.item_spell_mod(caster)
      total_mod = mod.to_i + spell_mod.to_i
      Global.logger.info "#{caster.name} rolling #{school} to cast #{spell}. Mod=#{mod} Item Mod=#{spell_mod} Off-school cast mod=#{cast_mod}"
      roll = caster.roll_ability(school, total_mod)
      die_result = roll[:successes]
      succeeds = Magic.spell_success(spell, die_result)
    end

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


    def self.cast_noncombat_spell(caster, name_string, spell, mod = nil, is_potion = false)
      success = "%xgSUCCEEDS%xn"
      target_num = Global.read_config("spells", spell, "target_num")
      effect = Global.read_config("spells", spell, "effect")
      damage_type = Global.read_config("spells", spell, "damage_type")
      client = Login.find_client(caster)
      if name_string != nil
        targets = Magic.parse_spell_targets(name_string, target_num)
      else
        targets = []
      end

      if targets == "too_many_targets"
        return [t('magic.too_many_targets', :spell => spell, :num => target_num)]
      elsif targets == "no_target"
        return [t('magic.invalid_name')]
      elsif targets == []
        if is_potion
          message = t('magic.use_potion', :name => caster.name, :potion => spell)
        else
          message = t('magic.casts_spell', :name => caster.name, :spell => spell, :mod => mod, :succeeds => success)
        end
      else
        messages = []
        names = []
        targets.each do |target|
          if ((effect == "Psionic" || damage_type == "Fire" || damage_type == "Cold") && !is_potion)
            message = Magic.check_spell_vs_shields(target, caster, spell, mod)
            if !message
              names.concat [target.name]
            end
          else
            names.concat [target.name]
          end
        end
        print_names = names.join(", ")
        if is_potion
         msg = [t('magic.use_potion_target', :name => caster.name, :potion => spell, :target => print_names)]
       else
         msg = [t('magic.casts_spell_with_target', :name => caster.name, :target => print_names, :spell => spell, :mod => mod, :succeeds => success)]
       end
      end
      if message
        message = [message]
        return message
      elsif print_names
        return msg
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
        return "too_many_targets"
      else
        return targets
      end
    end

    def self.cast_non_combat_heal(caster, name_string, spell, mod = nil, is_potion = false)
      room = caster.room
      client = Login.find_client(caster)
      target_num = Global.read_config("spells", spell, "target_num")
      heal_points = Global.read_config("spells", spell, "heal_points")

      if name_string != nil
        targets = Magic.parse_spell_targets(name_string, target_num)
      else
        targets = [caster]
      end
      if targets == "too_many_targets"
        return [t('magic.too_many_targets', :spell => spell, :num => target_num)]
      elsif targets == "no_target"
        return [t('magic.invalid_name')]
      else
        messages = []
        targets.each do |target|
          wound = FS3Combat.worst_treatable_wound(target)
          if (wound)
            FS3Combat.heal(wound, heal_points)
            if is_potion
              message = [t('magic.potion_heal', :name => caster.name, :potion => spell, :target => target.name, :points => heal_points)]
            else
              message = [t('magic.cast_heal', :name => caster.name, :spell => spell, :mod => mod, :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :points => heal_points)]
            end
          else
            if is_potion
              if caster.name == target.name
                message = [t('magic.potion_heal', :name => caster.name, :potion => spell, :target => target.name, :points => heal_points)]
              else
                message = [t('magic.potion_heal_no_effect_target', :name => caster.name, :potion => spell, :target => target.name)]
              end
            else
              message = [t('magic.cast_heal_no_effect', :name => caster.name, :spell => spell, :target => target.name, :mod => mod, :succeeds => "%xgSUCCEEDS%xn")]
            end
          end
          messages.concat message
        end
        return messages
      end
    end

    def self.cast_noncombat_shield(caster, target, spell, mod)
      school = Global.read_config("spells", spell, "school")
      shield_strength = caster.roll_ability(school)
      Global.logger.info "#{spell} Strength on #{target.name} set to #{shield_strength[:successes]}."
      if spell == "Mind Shield"
        # target.update(mind_shield: shield_strength[:successes])
        type = "psionic"
      elsif spell == "Endure Fire"
        target.update(endure_fire: shield_strength[:successes])
        type = "fire"
      elsif spell == "Endure Cold"
        target.update(endure_cold: shield_strength[:successes])
        type = "ice"
      end

      message = [t('magic.cast_shield', :name => caster.name, :spell => spell, :mod => mod, :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => type)]
      return message
    end



  end
end
