module AresMUSH
  module Events
    class DeleteEventRequestHandler
      def handle(request)
        event_id = request.args[:event_id]
        enactor = request.enactor
        
        event = Event[event_id.to_i]
        if (!event)
          return { error: "Event not found!" }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        can_manage = enactor && Events.can_manage_event(enactor, event)
        if (!can_manage)
          return { error: "You are not allowed to edit that event." }
        end
        
        Events.delete_event(event, enactor)
        {}
      end
    end
  end
end


