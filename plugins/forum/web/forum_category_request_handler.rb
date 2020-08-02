module AresMUSH
  module Forum
    class ForumCategoryRequestHandler
      def handle(request)
                
        category_id = request.args[:category_id] 
        enactor = request.enactor
        
        category = BbsBoard[category_id.to_i]
        if (!category)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request, true)
        return error if error

        if (!Forum.can_read_category?(enactor, category))
          return { error: t('forum.cannot_access_category') }
        end

        posts = category.bbs_posts.to_a.sort_by { |p| [ p.is_pinned? ? 1 : 0, p.last_updated ] }.reverse
           .map { |p| {
             id: p.id,
             category_id: p.bbs_board.id,
             title: p.subject,
             unread: enactor && p.is_unread?(enactor),
             date: p.created_date_str(enactor),
             author: p.author_name,
             last_activity: OOCTime.local_long_timestr(enactor, p.last_updated),
             last_updated_by: p.last_updated_by,
             is_pinned: p.is_pinned?,
             
           }}
              
         {
           id: category.id,
           name: category.name,
           description: Website.format_markdown_for_html(category.description),
           can_post: Forum.can_write_to_category?(enactor, category),
           posts: posts,
           authors: Forum.get_authorable_chars(enactor, category)
         }
      end
    end
  end
end