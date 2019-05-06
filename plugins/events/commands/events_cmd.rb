module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler

      def handle
        events = Event.sorted_events
        title = t('events.all_events_title')
        template = EventsListTemplate.new(events, title, enactor)
        client.emit template.render
      end
    end
  end
end
