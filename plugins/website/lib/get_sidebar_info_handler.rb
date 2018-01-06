module AresMUSH
  module Website
    class GetSidebarInfoRequestHandler
      def handle(request)
        {
          game: GetGameInfoRequestHandler.new.handle(request),
          upcoming_events: Events::UpcomingEventsRequestHandler.new.handle(request),
          recent_scenes: Scenes::RecentScenesRequestHandler.new.handle(request),
          happenings: Who::WhoRequestHandler.new.handle(request)
        }
      end
    end
  end
end