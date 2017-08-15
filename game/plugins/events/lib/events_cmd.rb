module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler

      def handle
        template = EventsListTemplate.new(Event.sorted_events, enactor)
        client.emit template.render
      end
    end
  end
end
