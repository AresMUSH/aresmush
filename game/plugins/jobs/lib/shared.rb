module AresMUSH
  module Jobs
    def self.can_access_jobs?(actor)
      return actor.has_any_role?(Global.config["jobs"]["roles"]["can_access_jobs"])
    end
    
    def self.categories
      Global.config["jobs"]["categories"]
    end
    
    def self.status_vals
      Global.config["jobs"]["status"].keys
    end
    
    def self.closed_jobs
      Job.all.select { |j| !j.is_open? }
    end
    
    def self.status_color(status)
      return "" if status.nil?
      config = Global.config["jobs"]["status"]
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
      Global.config["jobs"]["closed_status"]
    end
    
  end
end