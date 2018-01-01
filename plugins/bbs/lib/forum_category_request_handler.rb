module AresMUSH
  module Bbs
    class ForumCategoryRequestHandler
      def handle(request)
                
        char_id = request.args[:char_id]
        category_id = request.args[:category_id] 
        
        category = BbsBoard[category_id.to_i]
        if (!category)
          return { error: "Invalid category."}
        end
        
        if (char_id)
          char = Character.find_one_by_name(char_id)
          if (!char)
            return { error: "Character not found." }
          end
        else
          char = nil
        end

        if (!Bbs.can_read_board?(char, category))
          return { error: "You don't have access to that board." }
        end

        posts = category.bbs_posts
           .map { |p| {
             id: p.id,
             title: p.subject,
             unread: char && p.is_unread?(char),
             date: p.created_date_str(char),
             author: p.author_name,
           }}
           
         {
           id: category.id,
           name: category.name,
           can_post: Bbs.can_write_board?(char, category),
           posts: posts
         }
      end
    end
  end
end