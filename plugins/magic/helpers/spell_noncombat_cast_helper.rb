module AresMUSH
  module Magic

    def self.roll_noncombat_spell_success(caster_name, spell, mod = nil, dice = nil)
      if Character.named(caster_name)
        caster = Character.named(caster_name)
      else
        caster = caster_name
        is_npc = true
      end
      if is_npc
        Global.logger.info "#{caster_name} rolling #{dice} dice to cast #{spell}."
        roll = FS3Skills.roll_dice(dice)
        die_result = FS3Skills.get_success_level(roll)
        succeeds = Magic.spell_success(spell, die_result)
        Global.logger.info "#{caster_name} rolling #{dice} dice to cast #{spell}. Result: #{roll} (#{die_result} successes)"
      else
        if Magic.knows_spell?(caster, spell)
          school = Global.read_config("spells", spell, "school")
        else
          school = "Magic"
          cast_mod = FS3Skills.ability_rating(caster, "Magic") * 2
          mod = mod.to_i + cast_mod
        end

        spell_mod = Magic.item_spell_mod(caster)
        total_mod = mod.to_i + spell_mod.to_i
        Global.logger.info "#{caster.name} rolling #{school} to cast #{spell}. Mod=#{mod} Item Mod=#{spell_mod} Off-school cast mod=#{cast_mod} total=#{total_mod}"
        roll = caster.roll_ability(school, total_mod)
        die_result = roll[:successes]
        succeeds = Magic.spell_success(spell, die_result)
      end

      return {:succeeds => succeeds, :result => die_result}
    end

    def self.cast_noncombat_spell(caster_name, name_string, spell, mod = nil, result = nil, is_potion = false)
      success = "%xgSUCCEEDS%xn"
      target_num = Global.read_config("spells", spell, "target_num") || 1
      effect = Global.read_config("spells", spell, "effect")
      damage_type = Global.read_config("spells", spell, "damage_type")
      if Character.named(caster_name)
        caster = Character.named(caster_name)
        caster_name = caster.name
      else
        #is an npc
        caster = caster_name
      end

      if name_string != nil
        targets = Magic.parse_spell_targets(name_string, target_num)
      else
        targets = []
      end
      messages = []
      if targets == "too_many_targets"
        return [t('magic.too_many_targets', :spell => spell, :num => target_num)]
      elsif targets == "no_target"
        return [t('magic.invalid_name')]
      elsif targets == []
        if is_potion
          message = t('magic.use_potion', :name => caster_name, :potion => spell)
          messages.concat [message]
        else
          message = t('magic.casts_spell', :name => caster_name, :spell => spell, :mod => mod, :succeeds => success)
          messages.concat [message]
        end
      else
        names = []
        targets.each do |target|
          if ((effect == "Psionic" || damage_type == "Fire" || damage_type == "Cold") && !is_potion)
            message = Magic.check_spell_vs_shields(target, caster_name, spell, mod, result)
            if !message
              names.concat [target.name]
            else
              messages.concat [message]
            end
          else
            names.concat [target.name]
            print_names = names.join(", ")
            if is_potion
              message = [t('magic.use_potion_target', :name => caster_name, :potion => spell, :target => print_names)]
              messages.concat message
            else
              message = [t('magic.casts_spell_on_target', :name => caster_name, :target => print_names, :spell => spell, :mod => mod, :succeeds => success)]
              messages.concat message
            end
          end
        end
        return messages
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

    def self.print_target_names(name_string)
      target_names = name_string.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
      print_names = []
      target_names.each do |name|
        target = Character.named(name)
        return "no_target" if !target
        print_names << target.name
      end
      print_names = print_names.join(", ")
      return print_names
    end


    def self.cast_non_combat_heal(caster_name, name_string, spell, mod = nil, is_potion = false)
      target_num = Global.read_config("spells", spell, "target_num")
      heal_points = Global.read_config("spells", spell, "heal_points")
      if Character.named(caster_name)
        caster = Character.named(caster_name)
        caster_name = caster.name
      else
        #is an npc
        caster = caster_name
      end

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
              message = [t('magic.potion_heal', :name => caster_name, :potion => spell, :target => target.name, :points => heal_points)]
            else
              message = [t('magic.cast_heal', :name => caster_name, :spell => spell, :mod => mod, :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :points => heal_points)]
            end
          else
            if is_potion
              if caster_name == target.name
                message = [t('magic.potion_heal', :name => caster_name, :potion => spell, :target => target.name, :points => heal_points)]
              else
                message = [t('magic.potion_heal_no_effect_target', :name => caster_name, :potion => spell, :target => target.name)]
              end
            else
              message = [t('magic.cast_heal_no_effect', :name => caster_name, :spell => spell, :target => target.name, :mod => mod, :succeeds => "%xgSUCCEEDS%xn")]
            end
          end
          messages.concat message
        end
        return messages
      end
    end

    def self.cast_noncombat_shield(caster, caster_name, name_string, spell, mod, shield_strength)
      target_num = Global.read_config("spells", spell, "target_num")

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
          if spell == "Mind Shield"
            target.update(mind_shield: shield_strength)
            type = "psionic"
          elsif spell == "Endure Fire"
            target.update(endure_fire: shield_strength)
            type = "fire"
          elsif spell == "Endure Cold"
            target.update(endure_cold: shield_strength)
            type = "ice"
          end

          Global.logger.info "#{spell} strength on #{target.name} set to #{shield_strength}."
          message = [t('magic.cast_shield', :name => caster_name, :spell => spell, :mod => mod, :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => type)]
          puts "Triggering"
          messages.concat message
        end
      end
      return messages
    end


  end
end
