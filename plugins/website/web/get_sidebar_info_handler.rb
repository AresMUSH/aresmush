module AresMUSH
  module Website
    class GetSidebarInfoRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        if (enactor)
          if (Jobs.can_access_jobs?(enactor))
            job_activity = enactor.unread_jobs.count
          else
            job_activity = enactor.unread_requests.count
          end
        else
          job_activity = nil
        end
        
        if (enactor && enactor.token_secs_remaining < (8 * 60 * 60))
          token_expiry_warning = TimeFormatter.format(enactor.token_secs_remaining)
        else
          token_expiry_warning = nil
        end
        
        {
          timestamp: Time.now.getutc,
          game: GetGameInfoRequestHandler.new.handle(request),
          upcoming_events: Events::UpcomingEventsRequestHandler.new.handle(request),
          recent_scenes: Scenes::RecentScenesRequestHandler.new.handle(request),
          recent_forum: Forum::RecentForumPostsRequestHandler.new.handle(request),
          happenings: Who::WhoRequestHandler.new.handle(request),
          unread_mail: enactor ? enactor.unread_mail.count : nil,
          recent_changes: Website.get_recent_changes(true, 10),
          left_sidebar: Global.read_config('website', 'left_sidebar'),
          top_navbar: Global.read_config('website', 'top_navbar'),
          registration_required: Global.read_config("login", "portal_requires_registration"),
          job_activity: job_activity,
          jobs_admin: Jobs.can_access_jobs?(enactor),
          token_expiry_warning: token_expiry_warning
        }
      end
    end
  end
end