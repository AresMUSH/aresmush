module AresMUSH
  module Events
    class EventDetailTemplate < ErbTemplateRenderer
             
      attr_accessor :event
                     
      def initialize(event, enactor)
        @event = event
        @enactor = enactor
        super File.dirname(__FILE__) + "/event_detail.erb"        
      end

      def start_datetime_local
        @event.start_datetime_local(@enactor)
      end
      
      def start_time_standard
        @event.start_time_standard
      end
      
      def signup_comment(signup)
        signup.comment ? "- #{signup.comment}" : ""
      end
    end
  end
end

