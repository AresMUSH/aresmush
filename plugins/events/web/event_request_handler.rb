module AresMUSH
  module Events
    class EventRequestHandler
      def handle(request)
        event_id = request.args[:event_id]
        edit_mode = request.args[:edit_mode]
        enactor = request.enactor
        
        event = Event[event_id.to_i]
        if (!event)
          return { error: t('webportal.not_found') }
        end
        
        error = WebHelpers.check_login(request, true)
        return error if error
        
        datetime = OOCTime.format_date_time_for_entry(event.starts)
        
        if (edit_mode)
          description = WebHelpers.format_input_for_html(event.description)
        else
          description = WebHelpers.format_markdown_for_html(event.description)
        end
          
        {
          id: event.id,
          title: event.title,
          organizer: event.organizer_name,
          description: description,
          date: datetime.before(' '),
          time: datetime.after( ' '),
          can_manage: enactor && Events.can_manage_event(enactor, event),
          date_entry_format: Global.read_config("datetime", 'date_entry_format_help').upcase,
          start_datetime_local: event.start_datetime_local(request.enactor),
          start_time_standard: event.start_time_standard,
        }
        
      end
    end
  end
end


