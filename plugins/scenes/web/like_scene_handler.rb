module AresMUSH
  module Scenes
    class LikeSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        liked = request.args[:like].to_bool
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
       
        Global.logger.debug "Scene #{scene.id} #{liked ? 'liked' : 'unliked'} by #{enactor.name}."
       
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