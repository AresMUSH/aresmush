module AresMUSH
  module Website
    class GetSidebarInfoRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
                
        wiki_nav = []
        nav_list = Global.read_config('website', 'wiki_nav') || [ "Home" ]
        nav_list.each do |page_name|
          page = WikiPage.find_one_by_name(WikiPage.sanitize_page_name(page_name))
          if (page)
            wiki_nav << { url: page.name, heading: page.heading }
          else
            Global.logger.warn "Can't find wiki page #{page_name}."
          end
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
          registration_required: Global.read_config("website", "portal_requires_registration"),
          wiki_nav: wiki_nav
        }
      end
    end
  end
end