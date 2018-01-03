module AresMUSH
  module Scenes
    class DeleteSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        
        if (!scene)
          return { error: "Scene not found." }
        end
        
        if (!enactor.is_admin?)
          return { error: "You are not allowed to delete that scene." }
        end
        
        scene.delete
        {
        }
      end
    end
  end
end