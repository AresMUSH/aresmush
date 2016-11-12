module AresMUSH
  module Events
    class EventDetailTemplate < ErbTemplateRenderer
      include TemplateFormatters
             
      attr_accessor :event
                     
      def initialize(event, enactor)
        @event = event
        @enactor = enactor
        super File.dirname(__FILE__) + "/event_detail.erb"        
      end

      def view_url
        Events.calendar_view_url
      end
      
      def start_time_local
        @event.start_time_local(@enactor)
      end
      
      def start_time_standard
        @event.start_time_standard
      end
    end
  end
end

