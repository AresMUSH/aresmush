module AresMUSH
  module Forum
    class ForumListRequestHandler
      def handle(request)
                
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error
        
        categories = Forum.visible_categories(enactor)
           .select { |b| Forum.can_read_category?(enactor, b) }
           .map { |b| {
             id: b.id,
             name: b.name,
             description: b.description,
             unread: enactor && b.has_unread?(enactor),
             last_activity: last_activity(b, enactor)
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
        
        last_reply = BbsReply.all.select { |r| r.bbs_post.bbs_board == board }.sort_by { |b| b.created_at }.reverse.first
        last_post = board.last_post
        
        if (!last_reply && !last_post)
          return nil
        end
        
        last_reply_date = last_reply ? last_reply.created_at : Time.new(1999)
        last_post_date = last_post ? last_post.created_at : Time.new(1999)
        
        if (last_reply_date > last_post_date)
          post = last_reply.bbs_post
          type = 'reply'
          author_name = last_reply.author_name
          date = last_reply.created_at
        else
          post = last_post
          type = 'post'
          author_name = last_post.author_name
          date = last_post.created_at
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