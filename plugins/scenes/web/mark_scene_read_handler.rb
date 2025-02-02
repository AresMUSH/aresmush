module AresMUSH
  module Scenes
    class MarkSceneReadRequestHandler
      def handle(request)
        scene = Scene[request.args['id']]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.scene_is_private') }
        end
       
        scene.mark_read(enactor)
        if (enactor.unified_play_screen)
          AresCentral.play_screen_alts(enactor).each do |alt|
            next if alt == enactor
            scene.mark_read(alt)
          end
        end
       
        {}
      end
    end
  end
end