module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler

      def handle
        events = Event.sorted_events
        template = EventsListTemplate.new(events, enactor)
        client.emit template.render
      end
    end
  end
end
