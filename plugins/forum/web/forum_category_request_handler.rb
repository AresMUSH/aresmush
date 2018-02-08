module AresMUSH
  module Forum
    class ForumCategoryRequestHandler
      def handle(request)
                
        category_id = request.args[:category_id] 
        enactor = request.enactor
        
        category = BbsBoard[category_id.to_i]
        if (!category)
          return { error: "Invalid category."}
        end
        
        error = WebHelpers.check_login(request, true)
        return error if error

        if (!Forum.can_read_category?(enactor, category))
          return { error: "You don't have access to that category." }
        end

        posts = category.bbs_posts
           .map { |p| {
             id: p.id,
             title: p.subject,
             unread: enactor && p.is_unread?(enactor),
             date: p.created_date_str(enactor),
             author: p.author_name,
           }}
           
         {
           id: category.id,
           name: category.name,
           can_post: Forum.can_write_to_category?(enactor, category),
           posts: posts
         }
      end
    end
  end
end