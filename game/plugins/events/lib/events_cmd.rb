module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler

      def handle
        if (cmd.switch_is?("refresh"))
          Events.refresh_events
          client.emit_success t('events.events_refreshed')
          return
        end
        events = Events.upcoming_events
        template = EventsListTemplate.new(events, enactor)
        client.emit template.render
      end
    end
  end
end
