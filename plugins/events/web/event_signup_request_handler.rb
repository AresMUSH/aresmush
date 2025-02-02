module AresMUSH
  module Events
    class EventSignupRequestHandler
      def handle(request)
        event_id = request.args['event_id']
        comment = request.args['comment']
        enactor = request.enactor
        signup_as = Character.named(request.args['signup_as']) || enactor
        
        request.log_request
        
        event = Event[event_id.to_i]
        if (!event)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (!enactor.is_approved? || !signup_as.is_approved? || !Events.can_manage_signup?(event, signup_as, enactor))
          return { error: t('dispatcher.not_allowed') }
        end

        Global.logger.info "#{enactor.name} signing up #{signup_as.name} for event #{event.id}."
        Events.signup_for_event(event, signup_as, comment)
        
        {}
      end
    end
  end
end


