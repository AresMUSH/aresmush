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
        
        if (enactor && enactor.token_secs_remaining < (8 * 60 * 60) && enactor.token_secs_remaining > 0)
          token_expiry_warning = TimeFormatter.format(enactor.token_secs_remaining)
        else
          token_expiry_warning = nil
        end
                
        {
          timestamp: Time.now.getutc,
          game: GetGameInfoRequestHandler.new.handle(request),
          upcoming_events: Events::UpcomingEventsRequestHandler.new.handle(request),
          recent_scenes: Scenes.get_recent_scenes_web_data,
          recent_forum: Forum.get_recent_forum_posts_web_data(enactor),
          happenings: Who::WhoRequestHandler.new.handle(request),
          unread_mail: enactor ? enactor.unread_mail.count : nil,
          recent_changes: Website.recent_changes(true, 10),
          left_sidebar: Global.read_config('website', 'left_sidebar'),
          top_navbar: Global.read_config('website', 'top_navbar'),
          registration_required: Global.read_config("login", "portal_requires_registration"),
          server_time: OOCTime.server_timestr,
          job_activity: job_activity,
          jobs_admin: Jobs.can_access_jobs?(enactor),
          token_expiry_warning: token_expiry_warning,
          unread_pages: Page.has_unread_page_threads?(enactor),
          motd: Game.master.login_motd ? Website.format_markdown_for_html(Game.master.login_motd) : nil
        }
      end
    end
  end
end