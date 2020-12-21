module AresMUSH
  module Events
    class EventCancelSignupRequestHandler
      def handle(request)
        event_id = request.args[:event_id]
        comment = request.args[:comment]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        cancel_name = request.args[:name] || enactor.name
        event = Event[event_id.to_i]
        if (!event)
          return { error: t('webportal.not_found') }
        end
        
        error = Events.cancel_signup(event, cancel_name, enactor)
        if (error)
          return { error: error }
        end
           
        {}
      end
    end
  end
end


