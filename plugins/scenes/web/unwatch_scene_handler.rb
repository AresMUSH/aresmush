module AresMUSH
  module Scenes
    class UnwatchSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        scene.watchers.delete enactor
                    
        {}
      end
    end
  end
end