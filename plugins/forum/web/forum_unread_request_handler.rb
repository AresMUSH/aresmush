module AresMUSH
  module Forum
    class ForumUnreadRequestHandler
      def handle(request)
                
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        first_unread = nil
        category = nil
        BbsBoard.all_sorted.each do |b|
          category = b
          first_unread = b.first_unread(enactor)
          break if first_unread
        end
          
        if (!first_unread)
          return {}
        end
        
        {
          category_id: category.id,
          post_id: first_unread.id
        }
      end
    end
  end
end