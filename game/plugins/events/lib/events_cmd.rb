module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs

      def handle
        if (cmd.switch_is?("refresh"))
          Events.last_events = nil
        end
        events = Events.upcoming_events(30)
        template = EventsListTemplate.new(events, enactor)
        client.emit template.render
      end
    end
  end
end
