module AresMUSH
  module Forum
    class RecentForumPostsRequestHandler
      def handle(request)
                
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        posts = BbsPost.all.select { |p| Forum.can_read_category?(enactor, p.bbs_board ) }
           .sort_by { |p| p.last_updated }.reverse[0..6]
        
        recent = []
        
        posts.each do |p|
          if (p.bbs_replies.empty?)
            recent << {
              id: p.id,
              category_id: p.bbs_board.id,
              author: {
                name: p.author_name,
                icon: p.author ? Website.icon_for_char(p.author) : nil
               },
              date: p.created_date_str_short(enactor),
              subject: p.subject,
              is_reply: false
            }
          else
            last_reply = p.bbs_replies.to_a[-1]
            recent << {
              id: p.id,
              category_id: p.bbs_board.id,
              author: {
                name: last_reply.author_name,
                icon: last_reply.author ? Website.icon_for_char(last_reply.author) : nil
               },
              date: last_reply.created_date_str_short(enactor),
              subject: p.subject,
              is_reply: true
            }
          end
        end

        recent
      end
    end
  end
end