module AresMUSH
  module Events
    class EventDetailTemplate < ErbTemplateRenderer
             
      attr_accessor :event
                     
      def initialize(event, enactor)
        @event = event
        @enactor = enactor
        super File.dirname(__FILE__) + "/event_detail.erb"        
      end
    end
  end
end

