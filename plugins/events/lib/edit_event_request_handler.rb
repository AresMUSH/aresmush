module AresMUSH
  module Events
    class EditEventRequestHandler
      def handle(request)
        event_id = request.args[:event_id]
        date = request.args[:date]
        time = request.args[:time]
        title = request.args[:title]
        desc = request.args[:description]
        enactor = request.enactor
        
        event = Event[event_id.to_i]
        if (!event)
          return { error: "Event not found!" }
        end
        
        error = WebHelpers.validate_auth_token(request)
        return error if error
        
        can_manage = enactor && Events.can_manage_event(enactor, event)
        if (!can_manage)
          return { error: "You are not allowed to edit that event." }
        end
        
        if (title.blank? || desc.blank?)
          return { error: "Title and description are required." }
        end
      
        begin
          datetime = OOCTime.parse_datetime("#{date} #{time}".strip.downcase)
        rescue Exception => ex
          return { error: "Invalid date or time: #{ex}" }
        end
              
        Events.update_event(event, enactor, title, datetime, WebHelpers.format_input_for_mush(desc))
        
        {}
      end
    end
  end
end


