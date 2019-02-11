module AresMUSH  
  class BbsPost < Ohm::Model
    include ObjectModel
    
    attribute :subject
    attribute :message
        
    reference :author, "AresMUSH::Character"
    reference :bbs_board, "AresMUSH::BbsBoard"
    collection :bbs_replies, "AresMUSH::BbsReply"

    index :bbs_board
    
    before_delete :delete_replies
    
    def delete_replies
      bbs_replies.each { |r| r.delete }
    end
    
    def authored_by?(char)
      char == author
    end
    
    def last_updated
      if (bbs_replies.empty?)
        return self.updated_at
      else
        return bbs_replies.to_a[-1].updated_at
      end
    end
    
    def author_name
      !self.author ? t('forum.deleted_author') : self.author.name
    end
    
    def is_unread?(char)
      Forum.is_unread?(self, char)
    end
    
    def is_public?
      Forum.can_read_category?(nil, self.bbs_board)
    end
    
    def mark_read(char)
      Forum.mark_read(self, char)
    end
    
    def mark_unread
      Forum.mark_unread(self)
    end
    
    def reference_str
      "(#{category_index}/#{post_index})"
    end
    
    def post_index
      self.bbs_board.sorted_posts.index(self) + 1
    end
    
    def category_index
      self.bbs_board.category_index
    end
    
    def created_date_str(char)
      OOCTime.local_long_timestr(char, self.created_at)
    end
    
    def created_date_str_short(char)
      OOCTime.local_short_timestr(char, self.created_at)
    end
  end
end
