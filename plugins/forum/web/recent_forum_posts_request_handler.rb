module AresMUSH
  module Forum
    class RecentForumPostsRequestHandler
      def handle(request)
                
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        Forum.get_recent_forum_posts_web_data(enactor)
      end
    end
  end
end