module AresMUSH
  module Scenes
    class JoinSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!scene.participants.include?(enactor))
          Scenes.add_participant(scene, enactor, enactor)
        end
                  
        {}
      end
    end
  end
end