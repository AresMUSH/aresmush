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
          author_icon = last_post.author ?  Website.icon_for_char(last_post.author) : nil
          date = last_post.created_at
        else
          post = last_post
          type = 'reply'
          last_reply = replies[-1]
          author_name = last_reply.author_name
          author_icon = last_reply.author ?  Website.icon_for_char(last_reply.author) : nil
          date = last_reply.created_at
        end
        
        
        {
          id: post.id,
          subject: post.subject,
          author: {
            name: author_name,
            icon: author_icon
          },
          type: type,
          date: OOCTime.local_long_timestr(enactor, date)
        }
      end
    end
  end
end