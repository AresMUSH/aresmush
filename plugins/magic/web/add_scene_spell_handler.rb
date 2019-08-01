module AresMUSH
  module Magic
    class AddSceneSpellRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        caster = request.enactor
        spell_string = request.args[:spell_string]
        target_name = request.args[:target_name]
        mod = request.args[:mod]

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
          spell = spell_string
        end

        if !target_name.blank?
          target_num = Global.read_config("spells", spell, "target_num")
          if target == "no_target"
            return { error: t('magic.invalid_name') }
          end
        else
          target = [enactor]
        end

        if !Magic.knows_spell?(enactor, spell)
          return { error:  t('magic.dont_know_spell') }
        end

        target_optional = Global.read_config("spells", spell, "target_optional")
        if (!target_optional && !target_name.blank?)
          return { error: t('magic.doesnt_use_target') }
        end

        heal_points = Global.read_config("spells", spell, "heal_points")
        success = Magic.roll_noncombat_spell_success(enactor, spell, mod)

        if success == "%xgSUCCEEDS%xn"
          if heal_points
            message = Magic.cast_non_combat_heal(caster, target_name, spell, mod)
          elsif Magic.spell_shields.include?(spell)
            message = Magic.cast_noncombat_shield(caster, target, spell, mod)
          else
            message = Magic.cast_noncombat_spell(caster, target_name, spell, mod)
          end
          Magic.handle_spell_cast_achievement(caster)
        else
          if target_name.blank?
            message = [t('magic.casts_spell', :name => caster.name, :spell => spell, :mod => mod, :succeeds => success)]
          else
            names = []
            target.each do |target|
              names.concat [target.name]
            end
            names = names.join(", ")
            message = [t('magic.casts_spell_with_target', :name => caster.name, :spell => spell, :mod => mod, :target => names, :succeeds => success)]
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
