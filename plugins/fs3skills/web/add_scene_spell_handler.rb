module AresMUSH
  module FS3Skills
    class AddSceneSpellRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        spell_string = request.args[:spell_string]

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

        if (spell_string =~ /\=/)
          spell = spell_string.before("=")
          target_name = spell_string.after("=")
          target = Character.named(target_name)
          if (!target)
            return { error: t('custom.invalid_name') }
          end
        else
          spell = spell_string
        end

        success = Custom.roll_noncombat_spell_success(enactor, spell)

        if !target_name
          message = t('custom.casts_noncombat_spell', :name => enactor.name, :spell => spell, :mod => "", :succeeds => success)
        else
          messsage = t('custom.casts_noncombat_spell_with_target', :name => enactor.name, :target => target.name, :spell => spell, :mod => "", :succeeds => success)
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
