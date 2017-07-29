module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler

      def handle
        if (cmd.switch_is?("all"))        
          events = Event.all
        else
          events = Events.upcoming_events
        end
        template = EventsListTemplate.new(events, enactor)
        client.emit template.render
      end
    end
  end
end
