module AresMUSH
  module Places
    class LeavePlaceRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        if (scene.completed)
          return { error: t('places.scene_already_completed') }
        end
        place = enactor.place(scene.room)
      
        if (place)
          Places.leave_place(enactor, place)
        end
        
        {}
      end
    end
  end
end