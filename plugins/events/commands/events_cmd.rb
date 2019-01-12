module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler

      def handle
        if (cmd.switch_is?("all"))
          events = Event.sorted_events
          title = t('events.all_events_title')
        else
          events = Events.upcoming_events
          title = t('events.upcoming_events_title')
        end
        template = EventsListTemplate.new(events, title, enactor)
        client.emit template.render
      end
    end
  end
end
