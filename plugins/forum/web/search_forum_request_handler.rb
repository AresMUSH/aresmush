module AresMUSH
  module Forum
    class SearchForumRequestHandler
      def handle(request)

        searchTitle = (request.args[:searchTitle] || "").strip
        searchText = (request.args[:searchText] || "").strip
        searchAuthor = (request.args[:searchAuthor] || "").strip
        
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        posts = BbsPost.all.select { |p| Forum.can_read_category?(enactor, p.bbs_board) }

        if (!searchText.blank?)
          posts = posts.select { |p| "#{p.message} #{p.bbs_replies.map { |r| r.message }.join(' ')}" =~ /\b#{searchText}\b/i }
        end
        
        if (!searchTitle.blank?)
          posts = posts.select { |p| p.subject =~ /\b#{searchTitle}\b/i }
        end
        
        if (!searchAuthor.blank?)
          posts = posts.select { |p| p.author && (p.author.name.upcase == searchAuthor.upcase) }
        end

        posts.to_a.sort_by { |p| p.created_at }.reverse
                   .map { |p| {
                     id: p.id,
                     category_id: p.bbs_board.id,
                     title: p.subject,
                     unread: enactor && p.is_unread?(enactor),
                     date: p.created_date_str(enactor),
                     author: p.author_name,
                   }}
      end
    end
  end
end