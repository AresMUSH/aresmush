module AresMUSH
  module Events
    class EventsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        events = Event.sorted_events.map { |e| {
          id: e.id,
          title: e.title,
          organizer: { 
            name: e.character.name, 
            id: e.character.id, 
            icon: Website.icon_for_char(e.character) },
          start_datetime_local: e.start_datetime_local(enactor),
          start_time_standard: e.start_time_standard,
          content_warning: e.content_warning,
          is_signed_up: e.is_signed_up?(enactor),
          tags: e.content_tags
        }}
        
        
        {
          events: events,
          calendar_url: "#{AresMUSH::Game.web_portal_url}/events/ical"
        }
      end
    end
  end
end


