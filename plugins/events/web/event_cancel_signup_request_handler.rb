module AresMUSH
  module Events
    class EventCancelSignupRequestHandler
      def handle(request)
        event_id = request.args['event_id']
        comment = request.args['comment']
        enactor = request.enactor
        signup_char = Character.named(request.args['name']) || enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        event = Event[event_id.to_i]
        if (!event)
          return { error: t('webportal.not_found') }
        end
                
        error = Events.cancel_signup(event, signup_char, enactor)
        if (error)
          return { error: error }
        end
           
        {}
      end
    end
  end
end


