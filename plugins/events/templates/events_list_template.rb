module AresMUSH
  module Events
    class EventsListTemplate < ErbTemplateRenderer
             
      attr_accessor :events, :title
                     
      def initialize(events, title, enactor)
        @events = events
        @title = title
        @enactor = enactor
        super File.dirname(__FILE__) + "/events_list.erb"        
      end
      
      def start_datetime_local(event)
        event.start_datetime_local(@enactor)
      end
      
      def start_time_standard(event)
        event.start_time_standard
      end

    end
  end
end

