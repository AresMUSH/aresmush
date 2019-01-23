module AresMUSH
  module FS3Skills
    class AddSceneRollRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        roll_str = request.args[:roll_string]
        
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
        
        roll = FS3Skills.parse_and_roll(enactor, roll_str)
        roll_result = FS3Skills.get_success_level(roll)
        success_title = FS3Skills.get_success_title(roll_result)
        message = t('fs3skills.simple_roll_result', 
          :name => enactor.name,
          :roll => roll_str,
          :dice => FS3Skills.print_dice(roll),
          :success => success_title
        )
        
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