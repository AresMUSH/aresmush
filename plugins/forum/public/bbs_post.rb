module AresMUSH  
  class BbsPost < Ohm::Model
    include ObjectModel
    
    attribute :subject
    attribute :message
    attribute :is_pinned, :type => DataType::Boolean
        
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
    
    def sorted_replies
     bbs_replies.to_a.sort_by { |p| p.created_at }
   end
     
    def last_updated
      if (bbs_replies.empty?)
        return self.updated_at
      else
        return self.sorted_replies[-1].updated_at
      end
    end
    
    def last_updated_by
      if (bbs_replies.empty?)
        return self.author_name
      else
        updater = self.sorted_replies[-1].author
        return author ? author.name : t('global.deleted_character')
      end
    end
    
    def author_name
      !self.author ? t('global.deleted_character') : self.author.name
    end
    
    def is_unread?(char)
      Forum.is_unread?(self, char)
    end
    
    def is_public?
      Forum.can_read_category?(nil, self.bbs_board)
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
    
    def last_activity_time_str(viewer)
      elapsed = Time.now - self.last_updated
      if (elapsed < 86400 * 30)
        TimeFormatter.format(elapsed)
      else
        OOCTime.local_short_timestr(viewer, self.last_updated)
      end
    end
    
    def is_pinned?
      self.is_pinned
    end
  end
end
