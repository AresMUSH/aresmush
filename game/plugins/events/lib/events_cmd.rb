module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler

      def handle        
        events = Events.upcoming_events
        template = EventsListTemplate.new(events, enactor)
        client.emit template.render
      end
    end
  end
end
