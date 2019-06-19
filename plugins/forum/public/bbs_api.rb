module AresMUSH
  module Forum
    def self.has_unread_forum_posts?(char)
      BbsBoard.all.each do |b|
        if (b.has_unread?(char))
          return true
        end
      end
      return false
    end
    
    def self.system_post(category, subject, message)
      return if !category
      return if category.blank?
  
      Forum.post(category, subject, message, Game.master.system_character)
    end
    
    def self.get_recent_forum_posts_web_data(enactor)
      posts = Game.master.recent_forum_posts.map { |f| BbsPost[f] }
          .select { |f| f }
          .select { |f| Forum.can_read_category?(enactor, f.bbs_board) }[0..6]
      
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
