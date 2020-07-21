module AresMUSH
  module Forum
    class SearchForumRequestHandler
      def handle(request)

        search_title = (request.args[:searchTitle] || "").strip
        search_text = (request.args[:searchText] || "").strip
        search_author = (request.args[:searchAuthor] || "").strip
        
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        posts = BbsPost.all.select { |p| Forum.can_read_category?(enactor, p.bbs_board) }

        if (!search_title.blank?)
          posts = posts.select { |p| p.subject =~ /#{search_title}/i }
        end
        
        if (!search_author.blank?)
          posts = posts.select { |p| p.author && (p.author.name.upcase == search_author.upcase) }
        end

        if (!search_text.blank?)
          posts = posts.select { |p| "#{p.message} #{p.bbs_replies.map { |r| r.message }.join(' ')}" =~ /\b#{search_text}\b/i }
        end
        

        posts.to_a.sort_by { |p| p.created_at }.reverse
                   .map { |p| {
                     id: p.id,
                     category_id: p.bbs_board.id,
                     title: p.subject,
                     unread: enactor && p.is_unread?(enactor),
                     date: p.created_date_str(enactor),
                     author: p.author_name,
                     last_activity: p.last_activity_time_str(enactor)
                   }}
      end
    end
  end
end