module AresMUSH
  module Places
    class ViewPlacesRequestHandler
      def handle(request)
        scene = Scene[request.args['scene_id']]
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request, false)
        return error if error

        if (scene.completed)
          return { error: t('places.scene_already_completed') }
        end
        
        places = scene.room.places.to_a.sort_by { |p| p.name }.map { |p| {
          name: p.name,
          chars: p.characters.map { |c| {
            name: c.name,
            avatar: Website.avatar_info(c)
          }}
        }}
        
        { 
          places: places
        }
      end
    end
  end
end