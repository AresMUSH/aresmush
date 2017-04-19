module AresMUSH
  class Game
    attribute :next_job_number, :type => DataType::Integer, :default => 1
  end
  
  class Character
    
    collection :jobs, "AresMUSH::Job", :author
    
    def assigned_jobs
      Job.find(assigned_to_id: self.id)
    end
    
    def unread_jobs
      return [] if !Jobs.can_access_jobs?(self)
      Job.all.select { |j| j.is_unread?(self) }
    end
    
    def unread_requests
      if (Jobs.can_access_jobs?(self))
        return []
      end
      self.jobs.select { |r| r.is_unread?(self) }
    end
  end
  
  
  class Job < Ohm::Model
    include ObjectModel
    
    attribute :title
    attribute :description
    attribute :category
    attribute :status
    attribute :number, :type => DataType::Integer
    
    reference :author, "AresMUSH::Character"
    reference :assigned_to, "AresMUSH::Character"
    reference :approval_char, "AresMUSH::Character"

    collection :job_replies, "AresMUSH::JobReply"
    
    set :readers, "AresMUSH::Character"
    
    index :number

    before_delete :delete_replies
    
    def delete_replies
      job_replies.each { |r| r.delete }
    end
    
    def is_unread?(char)
      !readers.include?(char)
    end
      
    def is_open?
      self.status != "DONE"
    end
  end
  
  class JobReply < Ohm::Model
    include ObjectModel
    
    reference :job, "AresMUSH::Job"
    reference :author, "AresMUSH::Character"
    
    attribute :admin_only, :type => DataType::Boolean
    attribute :message
    
    def admin_only?
      self.admin_only
    end
  end
end