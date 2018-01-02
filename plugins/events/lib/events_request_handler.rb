module AresMUSH
  module Events
    class EventsRequestHandler
      def handle(request)
        events = Event.all.map { |e| {
          id: e.id,
          title: e.title,
          organizer: e.organizer_name,
          start_datetime_local: e.start_datetime_local(request.enactor),
          start_time_standard: e.start_time_standard
        }}
        
        {
          events: events,
          calendar_url: "#{AresMUSH::Game.web_portal_url}/events/ical"
        }
      end
    end
  end
end


