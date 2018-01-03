module AresMUSH
  module Events
    class CreateEventRequestHandler
      def handle(request)
        date = request.args[:date]
        time = request.args[:time]
        title = request.args[:title]
        desc = request.args[:description]
        enactor = request.enactor
        
        error = WebHelpers.validate_auth_token(request)
        return error if error
        
        can_create = enactor && enactor.is_approved?
        if (!can_create)
          return { error: "You are not allowed to create events." }
        end
        
        if (title.blank? || desc.blank?)
          return { error: "Title and description are required." }
        end
      
        begin
          puts "#{date} #{time}"
          datetime = OOCTime.parse_datetime("#{date} #{time}".strip.downcase)
        rescue Exception => ex
          return { error: "Invalid date or time: #{ex}" }
        end
      
        event = Events.create_event(enactor, title, datetime, WebHelpers.format_input_for_mush(desc))
        if (!event)
          return { error: "Something went wrong creating the event." }
        end
        
        {
          id: event.id
        }
      end
    end
  end
end


