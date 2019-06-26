module AresMUSH
  module Places
    class ChangePlaceRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        place_name = (request.args[:place_name] || "").titlecase
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        if (scene.completed)
          return { error: t('places.scene_already_completed') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (scene.room != enactor.room)
          return { error: t('places.cant_change_places_in_another_room') }
        end
        
        place = Places.find_place(enactor, place_name)
      
        if (!place)
          place = Place.create(name: place_name, room: enactor.room)
        end
        
        Places.join_place(enactor, place)
        
        {}
      end
    end
  end
end