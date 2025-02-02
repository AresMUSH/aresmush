module AresMUSH
  module Events
    class EventRequestHandler
      def handle(request)
        event_id = request.args['event_id']
        edit_mode = (request.args['edit_mode'] || "").to_bool
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
          Login.mark_notices_read(enactor, :event, event.id)
        end

        signups = event.ordered_signups.map { |s| 
          {
            char: {
                    name: s.char_name,
                    icon: s.character ? Website.icon_for_char(s.character) : nil
                  },
            comment: s.comment,
            author: enactor && s.character == enactor,
            can_edit: Events.can_manage_signup?(event, s.character, enactor)
            }}
        if (enactor)
          signupChars = AresCentral.alts(enactor).map { |p| { id: p.id, name: p.name, icon: Website.icon_for_char(p) }}   
        else
          sigupChars = []
        end
                  
        {
          id: event.id,
          title: event.title,
          organizer: { 
            name: event.character.name, 
            icon: Website.icon_for_char(event.character) },
          description: description,
          date: datetime.before(' '),
          time: datetime.after( ' '),
          tags: edit_mode ? event.content_tags.join(" ") : event.content_tags,
          signups: signups,
          can_manage: enactor && Events.can_manage_event?(enactor, event),
          date_entry_format: Global.read_config("datetime", 'date_entry_format_help').upcase,
          start_datetime_local: event.start_datetime_local(request.enactor),
          start_time_standard: event.start_time_standard,
          content_warning: content_warning,
          server_time: OOCTime.server_timestr,
          available_alts: signupChars
        }
        
      end
    end
  end
end


