module AresMUSH
  module Scenes
    class LikeSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        liked = request.args[:like].to_bool
        
        if (!scene)
          return { error: "Scene not found." }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: "You are not allowed to like scenes until you're approved." }
        end
      
        if (liked) 
          scene.like(enactor)
        else
          scene.unlike(enactor)
        end
                    
        {}
      end
    end
  end
end