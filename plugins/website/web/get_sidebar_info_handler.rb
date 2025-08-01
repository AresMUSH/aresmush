module AresMUSH
  module Website
    class GetSidebarInfoRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        
        if (enactor && enactor.token_secs_remaining < (8 * 60 * 60) && enactor.token_secs_remaining > 0)
          token_expiry_warning = TimeFormatter.format(enactor.token_secs_remaining)
        else
          token_expiry_warning = nil
        end
        
        if (enactor)
          notifications = enactor.unread_notifications.count
          if (enactor.handle)
            alts = AresCentral.alts(enactor) # Note - will include the original character
            alt_data = []
            if (alts.count > 1)
              alts.each do |alt|
                alt_data << {
                name: alt.name,
                id: alt.id,
                icon: Website.icon_for_char(alt)
                }
                if (alt != enactor)
                  notifications += alt.unread_notifications.count
                end
              end
            else
              alt_data = nil
            end
          else
            alt_data = nil
          end
        else
          notifications = 0
          alt_data = nil
        end
        
        {
          timestamp: Time.now.getutc,
          game: GetGameInfoRequestHandler.new.handle(request),
          upcoming_events: Events::UpcomingEventsRequestHandler.new.handle(request),
          recent_scenes: Scenes.get_recent_scenes_web_data,
          recent_forum: Forum.get_recent_forum_posts_web_data(enactor),
          happenings: Who::WhoRequestHandler.new.handle(request),
          recent_changes: Website.recent_changes(enactor, true, 10),
          left_sidebar: Global.read_config('website', 'left_sidebar'),
          hide_searchbox: Global.read_config('website', 'hide_searchbox'),
          top_navbar: Website.build_top_navbar(enactor),
          registration_required: Global.read_config("login", "portal_requires_registration"),
          server_time: OOCTime.server_timestr,
          jobs_admin: Jobs.can_access_jobs?(enactor),
          token_expiry_warning: token_expiry_warning,
          motd: Game.master.login_motd ? Website.format_markdown_for_html(Game.master.login_motd) : nil,
          notification_count: notifications == 0 ? nil : notifications,
          allow_web_tour: Login.allow_web_tour?,
          allow_web_registration: Login.allow_web_registration?,
          alts: alt_data,
          editor: (enactor ? enactor.website_editor : nil) || "WYSIWYG",
          
        }
      end
    end
  end
end