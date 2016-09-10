module AresMUSH
  class Game
    field :next_job_number, :type => Integer, :default => 1
  end
  
  class Character
    has_many :submitted_requests, :class_name => 'AresMUSH::Job', :inverse_of => :author
    has_many :assigned_jobs, :class_name => 'AresMUSH::Job', :inverse_of => :assigned_to
    
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
  
  class Job
    include SupportingObjectModel
    
    field :title, :type => String
    field :description, :type => String
    field :category, :type => String
    field :status, :type => String
    field :number, :type => Integer
    
    belongs_to :author, :class_name => "AresMUSH::Character", :inverse_of => :submitted_requests
    belongs_to :assigned_to, :class_name => "AresMUSH::Character", :inverse_of => :assigned_jobs
    belongs_to :approval_char, :class_name => "AresMUSH::Character", :inverse_of => :approval_job

    embeds_many :job_replies, order: :created_at.asc
    has_and_belongs_to_many :readers, :class_name => "AresMUSH::Character", :inverse_of => nil
    
    def is_unread?(char)
      !readers.include?(char)
    end
      
    def is_open?
      self.status != "DONE"
    end
  end
  
  class JobReply
    include SupportingObjectModel
    
    embedded_in :job
    belongs_to :author, :class_name => "AresMUSH::Character"
    
    field :admin_only, :type => Boolean
    field :message, :type => String
  end
end