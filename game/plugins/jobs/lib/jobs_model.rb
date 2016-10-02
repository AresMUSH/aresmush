module AresMUSH
  class Game
    attribute :next_job_number, DataType::Integer
  end
  
  class Character
    collection :submitted_requests, "AresMUSH::Job"
    set :assigned_jobs, "AresMUSH::Job"
    
    def unread_jobs
      if (!Jobs.can_access_jobs?(self))
        return []
      end
      Job.all.select { |j| j.is_unread?(self) }
    end
    
    def has_unread_jobs?
      !unread_jobs.empty?
    end
  
    def has_unread_requests?
      if (Jobs.can_access_jobs?(self))
        return false
      end
      requests = submitted_requests.select { |r| r.is_unread?(self) }
      !requests.empty?
    end
  end
  
  class Job < Ohm::Model
    include ObjectModel
    
    attribute :title
    attribute :description
    attribute :category
    attribute :status
    attribute :number, DataType::Integer
    
    reference :author, "AresMUSH::Character"
    reference :assigned_to, "AresMUSH::Character"
    reference :approval_char, "AresMUSH::Character"

    collection :job_replies, "AresMUSH::JobReply"
    set :readers, "AresMUSH::Character"
    
    index :number

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
    
    attribute :admin_only, DataType::Boolean
    attribute :message
  end
end