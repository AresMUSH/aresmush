module AresMUSH
  class JobReply < Ohm::Model
    include ObjectModel
    
    reference :job, "AresMUSH::Job"
    reference :author, "AresMUSH::Character"
    
    attribute :admin_only, :type => DataType::Boolean
    attribute :message
    
    def admin_only?
      self.admin_only
    end
    
    def created_date_str(char)
      OOCTime.local_long_timestr(char, self.created_at)
    end
    
    def author_name
      !self.author ? t('jobs.deleted_author') : self.author.name
    end
    
  end
end