$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Events
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("events", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "event"
        case cmd.switch
        when nil
          if (cmd.args)
            return EventDetailCmd
          else
            return EventsCmd
          end
        when "all", "upcoming"
          return EventsCmd
        when "create"
          return EventCreateCmd
        when "edit"
          return EventEditCmd
        when "delete"
          return EventDeleteCmd
        when "update"
          return EventUpdateCmd
        when "signup"
          return EventSignupCmd
        when "cancel"
          return EventCancelCmd
        end
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
    
    def self.get_web_request_handler(request)
       case request.cmd
       when "events"
         return EventsRequestHandler
       when "event"
         return EventRequestHandler
       when "createEvent"
         return CreateEventRequestHandler
       when "editEvent"
         return EditEventRequestHandler
       when "deleteEvent"
         return DeleteEventRequestHandler
       when "upcomingEvents"
         return UpcomingEventsRequestHandler
       when "eventSignup"
         return EventSignupRequestHandler
       when "eventCancelSignup"
         return EventCancelSignupRequestHandler
       end
       nil
    end
  end
end
