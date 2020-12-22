module AresMUSH
  module FS3Skills
    class SpendLuckRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        reason = request.args[:reason]
        
        request.log_request
        
        error = Website.check_login(request)
        return error if error
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end
        
        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end
        
        if (enactor.luck < 1)
          return { error: t('fs3skills.not_enough_points') }
        end
        FS3Skills.spend_luck(enactor, reason, scene)
       
        {
        }
      end
    end
  end
end