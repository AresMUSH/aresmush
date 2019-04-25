module AresMUSH
  module Custom

    attr_accessor :targets, :names

    def self.cast_noncombat_roll_spell_with_target(caster, name_string, spell, mod)
      enactor_room = caster.room
      success = Custom.roll_noncombat_spell_success(caster, spell, mod)
      target_num = Global.read_config("spells", spell, "target_num")
      targets = Custom.parse_spell_roll_targets(name_string, target_num)
      Global.logger.debug "Targets: #{targets}"

      if targets == t('custom.too_many_targets')
        enactor_room.emit t('custom.too_many_targets', :spell => spell, :num => target_num)
      elsif targets == "no_target"
        enactor_room.emit "%xrThat is not a character.%xn"
      else
        names = targets.map { |t| t.name }
        print_names = names.join(", ")
        enactor_room.emit t('custom.casts_noncombat_spell_with_target', :name => caster.name, :target => print_names, :spell => spell, :mod => mod, :succeeds => success)
      end
    end

    def self.parse_spell_roll_targets(name_string, target_num)
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

      Global.logger.debug "Target count: #{targets.count} target num #{target_num}"

    end

    def self.cast_non_combat_heal_with_target(caster, target, spell, mod)
      succeeds = Custom.roll_noncombat_spell_success(caster, spell, mod)
      room = caster.room
      if succeeds == "%xgSUCCEEDS%xn"
        wound = FS3Combat.worst_treatable_wound(target)
        heal_points = Global.read_config("spells", spell, "heal_points")
        if (wound)
          FS3Combat.heal(wound, heal_points)
          message = t('custom.cast_heal', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name, :points => heal_points)
          room.emit message
          if caster.room.scene
            Scenes.add_to_scene(caster.room.scene, message)
          end
        else
          message = t('custom.cast_heal_no_effect', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name)
          room.emit message
          if caster.room.scene
            Scenes.add_to_scene(caster.room.scene, message)
          end
        end
      else
        message = t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
        room.emit message
        if caster.room.scene
          Scenes.add_to_scene(caster.room.scene, message)
        end
      end
    end




  end
end
