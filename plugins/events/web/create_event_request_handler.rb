module AresMUSH
  module Events
    class CreateEventRequestHandler
      def handle(request)
        date = request.args[:date]
        time = request.args[:time]
        title = request.args[:title]
        desc = request.args[:description]
        tags = (request.args[:tags] || []).map { |t| t.downcase }.select { |t| !t.blank? }
        warning = request.args[:content_warning]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        can_create = enactor && enactor.is_approved?
        if (!can_create)
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
      
        event = Events.create_event(enactor, title, datetime, Website.format_input_for_mush(desc), Website.format_input_for_mush(warning), tags)
        if (!event)
          return { error: t('webportal.unexpected_error') }
        end
        
        {
          id: event.id
        }
      end
    end
  end
end


