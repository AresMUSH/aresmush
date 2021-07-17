module AresMUSH
  
  class Job < Ohm::Model
    include ObjectModel
    include HasContentTags
    
    attribute :title
    attribute :description
    attribute :category
    attribute :status
    attribute :date_closed, :type => DataType::Time
    
    reference :author, "AresMUSH::Character"
    reference :assigned_to, "AresMUSH::Character"
    reference :approval_char, "AresMUSH::Character"
    reference :job_category, "AresMUSH::JobCategory"
    
    collection :job_replies, "AresMUSH::JobReply"
    set :participants, "AresMUSH::Character"
        
    index :category
    index :status
    
    before_delete :delete_replies
    
    def delete_replies
      job_replies.each { |r| r.delete }
    end
    
    def is_unread?(char)
      Jobs.is_unread?(self, char)
    end
      
    def is_open?
      return !Jobs.closed_statuses.include?(self.status)
    end
    
    def is_active?
      return Jobs.active_statuses.include?(self.status)
    end
    
    def created_date_str(char)
      OOCTime.local_long_timestr(char, self.created_at)
    end
    
    def author_name
      !self.author ? t('global.deleted_character') : self.author.name
    end

    def all_parties
      parties = []
      if (self.author)
        parties << self.author
      end
      parties.concat self.participants.to_a
      if (self.assigned_to)
        parties << self.assigned_to
      end
      parties
    end
    
  end
end