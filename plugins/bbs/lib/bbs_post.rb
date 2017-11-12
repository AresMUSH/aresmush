module AresMUSH  
  class BbsPost < Ohm::Model
    include ObjectModel
    
    attribute :subject
    attribute :message
        
    reference :author, "AresMUSH::Character"
    reference :bbs_board, "AresMUSH::BbsBoard"
    collection :bbs_replies, "AresMUSH::BbsReply"
    set :readers, "AresMUSH::Character"
    
    index :bbs_board
    
    before_delete :delete_replies
    
    def delete_replies
      bbs_replies.each { |r| r.delete }
    end
    
    def authored_by?(char)
      char == author
    end
    
    def author_name
      !self.author ? t('bbs.deleted_author') : self.author.name
    end
    
    def is_unread?(char)
      !readers.include?(char)
    end
    
    def mark_read(char)
      readers.add char
    end
    
    def mark_unread
      readers.each { |r| readers.delete r }
    end
    
    def reference_str
      "(#{board_index}/#{post_index})"
    end
    
    def post_index
      self.bbs_board.bbs_posts.to_a.index(self) + 1
    end
    
    def board_index
      self.bbs_board.board_index
    end
    
    def created_date_str(char)
      OOCTime.local_long_timestr(char, self.created_at)
    end
    
    def created_date_str_short(char)
      OOCTime.local_short_timestr(char, self.created_at)
    end
  end
end
