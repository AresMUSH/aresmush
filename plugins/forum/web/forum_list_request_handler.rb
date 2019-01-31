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
             last_post: get_last_post(b, enactor)
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
      
      def get_last_post(board, enactor)
        last_post = board.last_post
        return nil if !last_post
        
        {
          id: last_post.id,
          subject: last_post.subject,
          author: last_post.author_name,
          date: last_post.created_date_str(enactor)
        }
      end
    end
  end
end