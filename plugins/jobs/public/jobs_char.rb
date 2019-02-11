module AresMUSH
  class Character
    
    attribute :jobs_filter, :default => "ACTIVE"
    attribute :read_jobs, :type => DataType::Array, :default => []

    collection :jobs, "AresMUSH::Job", :author
    
    def has_unread_jobs?
      !unread_jobs.empty?
    end
  
    def has_unread_requests?
      !unread_requests.empty?
    end  
    
    def assigned_jobs
      Job.find(assigned_to_id: self.id)
    end
    
    def unread_jobs
      return [] if !Jobs.can_access_jobs?(self)
      Job.all.select { |j| !Jobs.check_job_access(self, j) && j.is_unread?(self) }
    end
    
    def unread_requests
      if (Jobs.can_access_jobs?(self))
        return []
      end
      self.jobs.select { |r| r.is_unread?(self) }
    end
  end
end