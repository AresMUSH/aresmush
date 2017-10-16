module AresMUSH
  module Events
    class EventsListTemplate < ErbTemplateRenderer
             
      attr_accessor :events
                     
      def initialize(events, enactor)
        @events = events
        @enactor = enactor
        super File.dirname(__FILE__) + "/events_list.erb"        
      end
      
      def start_time_local(event)
        event.start_time_local(@enactor)
      end
      
      def start_time_standard(event)
        event.start_time_standard
      end

    end
  end
end

