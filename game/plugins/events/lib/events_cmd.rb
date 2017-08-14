module AresMUSH

  module Events
    class EventsCmd
      include CommandHandler

      def help
        "`events`  - Lists upcoming events\n" +
        "`event <#>` - Views an event"
      end
      
      def handle
        template = EventsListTemplate.new(Event.sorted_events, enactor)
        client.emit template.render
      end
    end
  end
end
