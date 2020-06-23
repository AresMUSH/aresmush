module AresMUSH
  class JobReadTracker < Ohm::Model
    include ObjectModel

    attribute :read_jobs, :type => DataType::Array, :default => []

    reference :character, "AresMUSH::Character"

    def is_unread?(job)
      jobs = self.read_jobs || []
      !jobs.include?("#{job.id}")
    end
    
    def mark_read(job)
      jobs = self.read_jobs || []
      jobs << job.id.to_s
      self.update(read_jobs: jobs)
    end

    def mark_unread(job)
      jobs = self.read_jobs || []
      jobs.delete job.id.to_s
      self.update(read_jobs: jobs)
    end
     
  end
end