module AresMUSH
  class Character
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
end