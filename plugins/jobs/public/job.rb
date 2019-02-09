module AresMUSH
  
  class Job < Ohm::Model
    include ObjectModel
    
    attribute :title
    attribute :description
    attribute :category
    attribute :status
    
    reference :author, "AresMUSH::Character"
    reference :assigned_to, "AresMUSH::Character"
    reference :approval_char, "AresMUSH::Character"

    collection :job_replies, "AresMUSH::JobReply"
        
    index :category

    before_delete :delete_replies
    
    def delete_replies
      job_replies.each { |r| r.delete }
    end
    
    def is_unread?(char)
      Jobs.is_unread?(self, char)
    end
      
    def is_open?
      self.status != "DONE"
    end
    
    def is_active?
      return false if self.status == "DONE"
      return false if self.status == "HOLD"
      return true
    end
    
    def created_date_str(char)
      OOCTime.local_long_timestr(char, self.created_at)
    end
    
    def author_name
      !self.author ? t('jobs.deleted_author') : self.author.name
    end
    
  end
end