module AresMUSH
  
  class Job < Ohm::Model
    include ObjectModel
    
    attribute :title
    attribute :description
    attribute :category
    attribute :status
    attribute :is_open
    attribute :date_closed
    
    reference :author, "AresMUSH::Character"
    reference :assigned_to, "AresMUSH::Character"
    reference :approval_char, "AresMUSH::Character"

    collection :job_replies, "AresMUSH::JobReply"
    set :participants, "AresMUSH::Character"
        
    index :category
    index :is_open
    
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
      !self.author ? t('global.deleted_character') : self.author.name
    end
    
    def self.open_jobs
      Job.find(is_open: "true")
    end
    
  end
end