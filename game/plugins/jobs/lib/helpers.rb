module AresMUSH
  module Jobs    
    def self.categories
      Global.read_config("jobs", "categories").map { |c| c.upcase }
    end
    
    def self.status_vals
      Global.read_config("jobs", "status").keys
    end
    
    def self.closed_jobs
      Job.all.select { |j| !j.is_open? }
    end
    
    def self.status_color(status)
      return "" if !status
      config = Global.read_config("jobs", "status")
      key = config.keys.find { |k| k.downcase == status.downcase }
      return "%xc" if !key
      return config[key]["color"]
    end
    
    def self.filtered_jobs(char, filter = nil)
      if (!filter)
        filter = char.jobs_filter
      end
      case filter
      when "ALL"
        jobs = Job.all.to_a
      when "ACTIVE"
        jobs = Job.all.select { |j| j.is_open? || j.is_unread?(char) }
      when "MINE"
        jobs = char.assigned_jobs.select { |j| j.is_open? }
      else
        jobs = Job.find(category: char.jobs_filter.upcase).select { |j| j.is_open? }
      end

      jobs = jobs || []
      jobs.sort_by { |j| j.number }
    end
    
    def self.with_a_job(client, number, &block)
      job = Job.find(number: number.to_i).first
      if (!job)
        client.emit_failure t('jobs.invalid_job_number')
        return
      end
      
      yield job
    end
    
    def self.with_a_request(client, enactor, number, &block)
      job = enactor.jobs.find(number: number.to_i).first
      if (!job)
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
      job.readers.add char
    end
    
    def self.closed_status
      Global.read_config("jobs", "closed_status")
    end
        
    def self.notify(job, message, author, notify_submitter = true)
      Global.client_monitor.logged_in.each do |other_client, other_char|
        job.readers.each { |r| job.readers.delete r }
        job.readers.add author
        
        if (Jobs.can_access_jobs?(other_char))
          other_client.emit_ooc message
        elsif (notify_submitter && (other_char == job.author))
          other_client.emit_ooc message + "  " + t('jobs.requests_cmd_hint')
        end
      end
      
      
      Global.client_monitor.notify_web_clients :new_job, message do |char|
         char && Jobs.can_access_jobs?(char)
      end
        
    end
  end
end