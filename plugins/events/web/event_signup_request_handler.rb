module AresMUSH
  module Events
    class EventSignupRequestHandler
      def handle(request)
        event_id = request.args[:event_id]
        comment = request.args[:comment]
        enactor = request.enactor
        
        event = Event[event_id.to_i]
        if (!event)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
              
        Events.signup_for_event(event, enactor, comment)
        
        {}
      end
    end
  end
end


