module AresMUSH
  class Character
    def has_unread_jobs?
      !unread_jobs.empty?
    end
  
    def has_unread_requests?
      !unread_requests.empty?
    end  
  end
  
  module Jobs
    module Api
      def self.create_job(category, title, description, author)
        Jobs.create_job(category, title, description, author)
      end
    
      def self.change_job_status(enactor, job, status, message = nil)
        Jobs.change_job_status(enactor, job, status, message)
      end
    
      def self.close_job(enactor, job, message = nil)
        Jobs.change_job_status(enactor, job, Jobs.closed_status, message)
      end
    end
  end
end