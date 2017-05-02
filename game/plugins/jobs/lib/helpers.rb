module AresMUSH
  module Jobs
    def self.can_access_jobs?(actor)
      actor.has_permission?("access_jobs")
    end
    
    def self.categories
      Global.read_config("jobs", "categories").map { |c| c.upcase }
    end
    
    def self.status_vals
      Global.read_config("jobs", "status").keys
    end
    
    def self.request_category
      Global.read_config("jobs", "request_category")
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
    
    def self.filtered_jobs(char)
      case (char.jobs_filter)
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
        
    def self.create_job(category, title, description, author)
      if (!Jobs.categories.include?(category))
        Global.logger.debug "Invalid job category #{category}."
        return { :job => nil, :error => t('jobs.invalid_category', :categories => Jobs.categories.join(" ")) }
      end
      
      job = Job.create(:author => author, 
        :title => title, 
        :description => description, 
        :category => category,
        :number => Game.master.next_job_number,
        :status => Global.read_config("jobs", "default_status"))
        
      game = Game.master
      game.update(next_job_number: game.next_job_number + 1)
      
      message = t('jobs.announce_new_job', :number => job.number, :title => job.title, :name => author.name)
      Jobs.notify(job, message, author, false)

      return { :job => job, :error => nil }
    end
    
    def self.change_job_status(enactor, job, status, message = nil)
      if (status == Jobs.closed_status)
        status_message = t('jobs.closed_job', :name => enactor.name, :status => status)
      else
        status_message = t('jobs.changed_job_status', :name => enactor.name, :status => status)
      end
            
      message = message ? "#{message}%R%R#{status_message}" : status_message

      Jobs.comment(job, enactor, message, false)
      job.update(status: status)
    end
    
    def self.close_job(enactor, job, message = nil)
      Jobs.change_job_status(enactor, job, Jobs.closed_status, message)
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
    end
  end
end