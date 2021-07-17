module AresMUSH
  module Places
    class ChangePlaceRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        place_name = (request.args[:place_name] || "").titlecase
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

        place = Places.find_place(scene.room, place_name)
      
        if (!place)
          place = Place.create(name: place_name, room: scene.room)
        end
        
        Places.join_place(sender, place)
        
        {}
      end
    end
  end
end