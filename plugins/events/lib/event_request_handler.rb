module AresMUSH
  module Events
    class EventRequestHandler
      def handle(request)
        event_id = request.args[:event_id]
        enactor = request.enactor
        
        event = Event[event_id.to_i]
        if (!event)
          return { error: "Event not found!" }
        end
        
        {
          id: event.id,
          title: event.title,
          organizer: event.organizer_name,
          description: WebHelpers.format_markdown_for_html(event.description),
          start_datetime_local: event.start_datetime_local(request.enactor),
          start_time_standard: event.start_time_standard,
          can_manage: enactor && Events.can_manage_event(enactor, event)
        }
      end
    end
  end
end


