module AresMUSH
  module Utils
    class RollDiceRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        dice_str = request.args[:dice_string]
        
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
        
        if (!scene.room)
          raise "Trying to emit to a scene that doesn't have a room."
        end

        Global.logger.debug "#{enactor.name} rolling #{dice_str} in scene #{scene.id}."
        args = ArgParser.parse(/(?<num>[\d]*)[dD](?<sides>[\d]+$)/, dice_str)
        num = (args.num || "0").to_i
        sides =( args.sides || "0").to_i

        message = Utils.roll_dice(enactor.name, num, sides)
        
        if (!message)
          return { error: t('dice.invalid_dice_string') }
        end

        scene.room.emit_ooc message
        Scenes.add_to_scene(scene, message, Game.master.system_character, false, true)
        
        {}
      end
    end
  end
end