module AresMUSH
  module Forum
    class ForumListRequestHandler
      def handle(request)
                
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error
        
        categories = Forum.visible_categories(enactor)
           .sort_by { |b| [ Forum.can_read_category?(enactor, b) ? 0 : 1, b.order ] }
           .map { |b| {
             id: b.id,
             name: b.name,
             description: Website.format_markdown_for_html(b.description),
             unread: enactor && b.has_unread?(enactor),
             last_activity: last_activity(b, enactor),
             can_read: Forum.can_read_category?(enactor, b)
           }}
           
       hidden =Forum.hidden_categories(enactor)
          .map { |b| {
             id: b.id,
             name: b.name   
          }}
        
          
          {
            categories: categories,
            hidden: hidden,
            is_muted: Forum.is_forum_muted?(enactor)
          }
      end
      
      def last_activity(board, enactor)
        return nil if !Forum.can_read_category?(enactor, board)
        
        last_post = board.last_post_with_activity
        if (!last_post)
          return nil
        end
        
        replies = last_post.sorted_replies
        if (replies.empty?)
          post = last_post
          type = 'post'
          author_name = last_post.author_name
          date = last_post.created_at
        else
          post = last_post
          type = 'reply'
          author_name = replies[-1].author_name
          date = replies[-1].created_at
        end
        
        
        {
          id: post.id,
          subject: post.subject,
          author: author_name,
          type: type,
          date: OOCTime.local_long_timestr(enactor, date)
        }
      end
    end
  end
end