module AresMUSH
  module Magic
    class AddSceneSpellRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        caster = request.enactor
        caster_name = caster.name
        spell_string = request.args[:spell_string]
        target_name_arg = request.args[:target_name]
        mod = request.args[:mod]
        if !target_name_arg.blank?
          has_target = true
        end

        if (!scene)
          return { error: t('webportal.not_found') }
        end

        error = Website.check_login(request)
        return error if error

        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end

        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end

        if !Magic.is_spell?(spell_string)
          return { error: t('magic.not_spell') }
        else
          spell = spell_string.titlecase
        end

        # target_optional = Global.read_config("spells", spell, "target_optional")
        # if (!target_optional && !target_name_arg.blank?)
        #   return { error: t('magic.doesnt_use_target') }
        # end

        target_num = Global.read_config("spells", spell, "target_num")
        if !target_name_arg.blank?
          if !target_num
            return { error: t('magic.doesnt_use_target') }
          else
            target_name_string = target_name_arg
          end
        else
          target_name_string = enactor.name
        end

        if !Magic.knows_spell?(enactor, spell)
          return { error:  t('magic.dont_know_spell') }
        end

        heal_points = Global.read_config("spells", spell, "heal_points")
        success = Magic.roll_noncombat_spell_success(enactor.name, spell, mod, dice = nil)
        print_names = Magic.print_target_names(target_name_string)

        if success[:succeeds] == "%xgSUCCEEDS%xn"
          if heal_points
            message = Magic.cast_non_combat_heal(caster_name, target_name_string, spell, mod)
          elsif Magic.spell_shields.include?(spell)
            message = Magic.cast_noncombat_shield(caster, caster_name, target_name_string, spell, mod, success[:result])
          else
            if has_target
              message = Magic.cast_noncombat_spell(caster_name, target_name_string, spell, mod, success[:result])
            else
              message = Magic.cast_noncombat_spell(caster_name, target_name_string=nil, spell, mod, success[:result])
            end
          end
          Magic.handle_spell_cast_achievement(caster)
        else
          if target_name_arg.blank?
            message = [t('magic.casts_spell', :name => caster.name, :spell => spell, :mod => mod, :succeeds => success[:succeeds])]
          else
            message = [t('magic.casts_spell_on_target', :name => caster.name, :spell => spell, :mod => mod, :target => print_names, :succeeds => success[:succeeds])]
          end
        end
        message.each do |msg|
          Scenes.add_to_scene(scene, msg)

          if (scene.room)
            scene.room.emit msg
          end
        end

        {
        }
      end
    end
  end
end
