module AresMUSH
  class ReadTracker

    attribute :read_jobs, :type => DataType::Array, :default => []

    def is_job_unread?(job)
      jobs = self.read_jobs || []
      !jobs.include?("#{job.id}")
    end
    
    def mark_job_read(job)
      jobs = self.read_jobs || []
      jobs << job.id.to_s
      self.update(read_jobs: jobs.uniq)
    end

    def mark_job_unread(job)
      jobs = self.read_jobs || []
      jobs.delete job.id.to_s
      self.update(read_jobs: jobs.uniq)
    end
     
  end
end