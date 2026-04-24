module AresMUSH
  module Events
    class CreateEventSceneRequestHandler
      def handle(request)
        event_id = request.args['event_id']
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        event = Event[event_id.to_i]
        if (!event)
          return { error: t('webportal.not_found') }
        end        
        
        scene = Events.create_event_scene(event, enactor)
        {
          scene_id: scene.id
        }
      end
    end
  end
end


