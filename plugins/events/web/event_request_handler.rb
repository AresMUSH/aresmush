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
        
        error = Website.check_login(request, true)
        return error if error
        
        datetime = OOCTime.format_date_time_for_entry(event.starts)
        
        if (edit_mode)
          description = Website.format_input_for_html(event.description)
          content_warning = Website.format_input_for_html(event.content_warning)
        else
          description = Website.format_markdown_for_html(event.description)
          content_warning = event.content_warning
        end
        
        if (enactor)
          current_signup = event.signups.select { |s| s.character == enactor }.first
        else
          current_signup = nil
        end

        if (enactor)
          Login.mark_notices_read(enactor, :event, event.id)
        end

        signups = event.ordered_signups.map { |s| 
          {
            char: {
                    name: s.char_name,
                    icon: s.character ? Website.icon_for_char(s.character) : nil
                  },
            comment: s.comment,
            author: enactor && s.character == enactor
            }}
                  
        {
          id: event.id,
          title: event.title,
          organizer: event.organizer_name,
          description: description,
          date: datetime.before(' '),
          time: datetime.after( ' '),
          tags: event.tags,
          signups: signups,
          signed_up: !!current_signup,
          signup_comment: current_signup ? current_signup.comment : nil,
          can_manage: enactor && Events.can_manage_event(enactor, event),
          date_entry_format: Global.read_config("datetime", 'date_entry_format_help').upcase,
          start_datetime_local: event.start_datetime_local(request.enactor),
          start_time_standard: event.start_time_standard,
          content_warning: content_warning,
          server_time: OOCTime.server_timestr
        }
        
      end
    end
  end
end


