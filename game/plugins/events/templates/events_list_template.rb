module AresMUSH
  module Events
    class EventsListTemplate < ErbTemplateRenderer
             
      attr_accessor :events
                     
      def initialize(events, enactor)
        @events = events
        @enactor = enactor
        super File.dirname(__FILE__) + "/events_list.erb"        
      end
      
      def color(event)
        event.is_past? ? "%xh%xx" : ""
      end
    end
  end
end

