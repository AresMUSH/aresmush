module AresMUSH
  module Events
    class UpcomingEventsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        Events.upcoming_events[0..5].map { |e| {
          id: e.id,
          title: e.title,
          organizer: e.organizer_name,
          start_datetime_local: e.start_datetime_local(enactor),
          start_time_standard: e.start_time_standard,
          content_warning: e.content_warning,
          is_signed_up: e.is_signed_up?(enactor)
        }}
      end
    end
  end
end


