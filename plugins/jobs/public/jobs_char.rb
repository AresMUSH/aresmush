module AresMUSH
  class Character
    
    attribute :jobs_filter, :default => "ACTIVE"
    attribute :jobs_subscription, :type => DataType::Boolean
    
    # OBSOLETE - use read_tracker instead.
    attribute :read_jobs, :type => DataType::Array, :default => []

    collection :jobs, "AresMUSH::Job", :author
    
    before_delete :delete_job_participation
    
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
      tracker = self.get_or_create_read_tracker
      read_jobs = tracker ? tracker.read_jobs : []
      staff_jobs = Jobs.accessible_jobs(self).select { |j| !read_jobs.include?(j.id) }
      their_jobs = self.unread_requests
      
      return staff_jobs.concat(their_jobs).uniq
    end
    
    def unread_requests
      self.requests.select { |r| r.is_unread?(self) }
    end
    
    def requests
      self.jobs.to_a.concat(Job.all.select { |j| j.participants.include?(self) })
    end
    
    def delete_job_participation
      Job.all.each do |j|
        Database.remove_from_set j.participants, self
      end
    end
  end
end