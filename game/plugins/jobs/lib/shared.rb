module AresMUSH
  module Jobs
    def self.can_access_jobs?(actor)
      return actor.has_any_role?(Global.read_config("jobs", "roles", "can_access_jobs"))
    end
    
    def self.categories
      Global.read_config("jobs", "categories")
    end
    
    def self.status_vals
      Global.read_config("jobs", "status").keys
    end
    
    def self.closed_jobs
      Job.all.select { |j| !j.is_open? }
    end
    
    def self.status_color(status)
      return "" if status.nil?
      config = Global.read_config("jobs", "status")
      key = config.keys.find { |k| k.downcase == status.downcase }
      return "%xc" if key.nil?
      return config[key]["color"]
    end
    
    def self.with_a_job(client, number, &block)
      job = Job.where(number: number.to_i).first
      if (job.nil?)
        client.emit_failure t('jobs.invalid_job_number')
        return
      end
      
      yield job
    end
    
    def self.with_a_request(client, number, &block)
      job = client.char.submitted_requests.where(number: number.to_i).first
      if (job.nil?)
        client.emit_failure t('jobs.invalid_job_number')
        return
      end
      
      yield job
    end
    
    def self.comment(job, author, message, admin_only)
      JobReply.create(:author => author, 
        :job => job,
        :admin_only => admin_only,
        :message => message)
      if (admin_only)
        notification = t('jobs.discussed_job', :name => author.name, :number => job.number, :title => job.title)
        Jobs.notify(job, notification, author, false)
      else
        notification = t('jobs.responded_to_job', :name => author.name, :number => job.number, :title => job.title)
        Jobs.notify(job, notification, author)
      end
    end
    
    def self.mark_read(job, char)
      job.readers << char
      job.save
    end
    
    def self.closed_status
      Global.read_config("jobs", "closed_status")
    end
    
    def self.get_job_display(client, job)      
      replies = Jobs.can_access_jobs?(client.char) ? job.job_replies : job.job_replies.select { |r| !r.admin_only}
      template = JobTemplate.new(client, job, replies)
      template.display
    end
  end
end