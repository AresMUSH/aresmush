module AresMUSH
  module FS3Skills
    class AddSceneSpellRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        caster = request.enactor
        spell_string = request.args[:spell_string]
        target_name = request.args[:target_name]
        mod = request.args[:mod]

        if !target_name.blank?
          target = Character.named(target_name)
          if !target
            return { error: "That is not a character." }
          end
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

        if !Custom.is_spell?(spell_string)
          return { error: t('custom.not_spell') }
        else
          spell = spell_string
        end

        if !Custom.knows_spell?(enactor, spell)
          return { error:  t('custom.dont_know_spell') }
        end

        heal_points = Global.read_config("spells", spell, "heal_points")
        success = Custom.roll_noncombat_spell_success(enactor, spell, mod)

        if target_name.blank?
          if success == "%xgSUCCEEDS%xn"
            if heal_points
              message = Custom.cast_non_combat_heal(caster, caster.name, spell, mod)
            elsif Custom.spell_shields.include?(spell)
              message = Custom.cast_noncombat_shield(caster, caster, spell, mod)
            else
              message = Custom.cast_noncombat_spell(caster, nil, spell, mod)
            end
            Custom.handle_spell_cast_achievement(caster)
          else
            message = t('custom.casts_noncombat_spell', :name => caster.name, :spell => spell, :mod => mod, :succeeds => success)

          end
        else
          target_optional = Global.read_config("spells", spell, "target_optional")
          if !target_optional
            return { error: t('custom.doesnt_use_target') }
          end

          if success == "%xgSUCCEEDS%xn"
            if heal_points
              message = Custom.cast_non_combat_heal(caster, target_name, spell, mod)
            elsif Custom.spell_shields.include?(spell)
              message = Custom.cast_noncombat_shield(caster, caster, spell, mod)
            else
              message = Custom.cast_noncombat_spell(caster, target_name, spell, mod)

            end
            Custom.handle_spell_cast_achievement(caster)
          else
            #Spell doesn't succeed
            message = t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => success)
          end
        end

        Scenes.add_to_scene(scene, message, Game.master.system_character)

        if (scene.room)
          scene.room.emit message
        end

        {
        }
      end
    end
  end
end
