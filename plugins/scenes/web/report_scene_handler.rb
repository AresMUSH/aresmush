module AresMUSH
  module Scenes
    class ReportSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        reason = request.args[:reason]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('dispatcher.not_allowed') }
        end
        
        Scenes.report_scene(enactor, scene, reason) 

        {}
      end
    end
  end
end