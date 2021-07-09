module AresMUSH
  module Places
    class LeavePlaceRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor        
        sender_name = request.args[:sender]

        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end

        sender = Character.named(sender_name)
        if (!sender)
          return { error: t('webportal.not_found') }
        end
        
        if (!AresCentral.is_alt?(sender, enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (scene.completed)
          return { error: t('places.scene_already_completed') }
        end
        place = sender.place(scene.room)
      
        if (place)
          Places.leave_place(sender, place)
        end
        
        {}
      end
    end
  end
end