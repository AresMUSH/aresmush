module AresMUSH
  module Events
    class EditEventRequestHandler
      def handle(request)
        event_id = request.args[:event_id]
        date = request.args[:date]
        time = request.args[:time]
        title = request.args[:title]
        desc = request.args[:description]
        warning = request.args[:content_warning]
        tags = (request.args[:tags] || []).map { |t| t.downcase }.select { |t| !t.blank? }
        enactor = request.enactor
        
        event = Event[event_id.to_i]
        if (!event)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        can_manage = enactor && Events.can_manage_event(enactor, event)
        if (!can_manage)
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (title.blank? || desc.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
      
        begin
          datetime, notused, error = Events.parse_date_time_desc("#{date} #{time}/notused".strip.downcase)

          if (error)
            return { error: error }
          end

        rescue Exception => ex
          format_help = Global.read_config("datetime", "date_and_time_entry_format_help")
          return { error: t('events.invalid_event_date', :format_str => format_help ) }
        end

        Events.update_event(event, enactor, title, datetime, Website.format_input_for_mush(desc), Website.format_input_for_mush(warning), tags)
        
        {}
      end
    end
  end
end


