module AresMUSH
  module Events
    class EventCancelSignupRequestHandler
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
              
        signup = event.signups.select { |s| s.character == enactor }.first
        if (signup)
          signup.delete
        end
        
        {}
      end
    end
  end
end


