module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler

      def handle
        if (cmd.switch_is?("refresh"))
          Events.refresh_events(30)
          client.emit_success t('events.events_refreshed')
          return
        end
        events = Events.upcoming_events(30)
        template = EventsListTemplate.new(events, enactor)
        client.emit template.render
      end
    end
  end
end
