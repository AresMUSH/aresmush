module AresMUSH
  module Events
    class GetEventForEditingRequestHandler
      def handle(request)
        event_id = request.args[:event_id]
        enactor = request.enactor
        
        event = Event[event_id.to_i]
        if (!event)
          return { error: "Event not found!" }
        end
        
        datetime = OOCTime.format_date_time_for_entry(event.starts)
        
        {
          id: event.id,
          title: event.title,
          organizer: event.organizer_name,
          description: event.description,
          date: datetime.before(' '),
          time: datetime.after( ' '),
          can_manage: enactor && Events.can_manage_event(enactor, event),
          date_entry_format: Global.read_config('date_and_time', 'date_entry_format_help').upcase          
        }
      end
    end
  end
end


