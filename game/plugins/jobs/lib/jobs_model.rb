module AresMUSH
  class Game
    attribute :next_job_number, :type => DataType::Integer, :default => 1
  end
  
  class Character
    
    collection :job_read_marks, "AresMUSH::JobReadMark"
    collection :jobs, "AresMUSH::Job", :author
    
    before_delete :delete_job_read_marks
    
    def delete_job_read_marks
      self.job_read_marks.each { |j| j.delete }
    end
    
    def assigned_jobs
      Job.find(assigned_to_id: self.id)
    end
    
    def unread_jobs
      return [] if !Jobs.can_access_jobs?(self)
      read_jobs = self.job_read_marks.map { |m| m.job }
      Job.all.select { |j| !read_jobs.include?(j) }
    end
    
    def unread_requests
      if (Jobs.can_access_jobs?(self))
        return []
      end
      self.jobs.select { |r| r.is_unread?(self) }
    end
  end
  
  class JobReadMark < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    reference :job, "AresMUSH::Job"
    
    def self.find_mark(job, char)
      JobReadMark.find(character_id: char.id).combine(job_id: job.id).first
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
    
    index :number

    before_delete :delete_replies
    
    def delete_replies
      job_replies.each { |r| r.delete }
    end
    
    def is_unread?(char)
      !JobReadMark.find_mark(self, char)
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