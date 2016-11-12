module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs

      def handle
        events = Events.upcoming_events(30)
        template = EventsListTemplate.new(events, enactor)
        client.emit template.render
      end
    end
  end
end
