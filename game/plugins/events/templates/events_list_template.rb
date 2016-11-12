module AresMUSH
  module Events
    class EventsListTemplate < ErbTemplateRenderer
      include TemplateFormatters
             
      attr_accessor :events
                     
      def initialize(events, enactor)
        @events = events
        @enactor = enactor
        super File.dirname(__FILE__) + "/events_list.erb"        
      end


      def view_url
        Events.calendar_view_url
      end
      
      def event_starts(event)
        event.formatted_start_time(@enactor)
      end
    end
  end
end

