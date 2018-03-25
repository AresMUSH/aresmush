module AresMUSH
  module Website
    class GetSidebarInfoRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request, true)
        return error if error
                
        {
          timestamp: Time.now.getutc,
          game: GetGameInfoRequestHandler.new.handle(request),
          upcoming_events: Events::UpcomingEventsRequestHandler.new.handle(request),
          recent_scenes: Scenes::RecentScenesRequestHandler.new.handle(request),
          recent_forum: Forum::RecentForumPostsRequestHandler.new.handle(request),
          happenings: Who::WhoRequestHandler.new.handle(request),
          unread_mail: enactor ? enactor.unread_mail.count : nil,
          recent_changes: WebHelpers.get_recent_changes(true, 10),
          registration_required: Global.read_config("website", "portal_requires_registration")
        }
      end
    end
  end
end