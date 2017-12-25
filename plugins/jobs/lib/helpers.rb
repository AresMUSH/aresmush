module AresMUSH
  module Jobs    
      
    def self.can_access_jobs?(actor)
      actor.has_permission?("access_jobs")
    end
    
    def self.categories
      Global.read_config("jobs", "categories").keys.map { |c| c.upcase }
    end
    
    def self.status_vals
      Global.read_config("jobs", "status").keys
    end
    
    def self.closed_jobs
      Job.all.select { |j| !j.is_open? }
    end
    
    def self.can_access_category?(actor, category)
      return true if actor.is_admin?
      return false if !Jobs.can_access_jobs?(actor)
      cats = Global.read_config("jobs", "categories")
      roles = cats[category.upcase]['roles']
      return false if !roles      
      actor.has_any_role?(roles)
    end

    def self.visible_replies(actor, job)
      if (Jobs.can_access_category?(actor, job.category))
        job.job_replies.to_a
      else
        job.job_replies.select { |r| !r.admin_only}
      end
    end
    
    def self.category_color(category)
      return "" if !category
      config = Global.read_config("jobs", "categories")
      key = config.keys.find { |k| k.downcase == category.downcase }
      reutrn "%xh" if !key
      return config[key]["color"]
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
      when "ACTIVE", nil
        jobs = Job.all.select { |j| j.is_open? || j.is_unread?(char) }
      when "MINE"
        jobs = char.assigned_jobs.select { |j| j.is_open? }
      else
        jobs = Job.find(category: char.jobs_filter.upcase).select { |j| j.is_open? }
      end

      jobs = jobs || []
      jobs = jobs.select { |j| Jobs.can_access_category?(char, j.category) }
      jobs.sort_by { |j| j.number }
    end
    
    def self.with_a_job(char, client, number, &block)
      job = Job.find(number: number.to_i).first
      if (!job)
        client.emit_failure t('jobs.invalid_job_number')
        return
      end
      
      if (!Jobs.can_access_category?(char, job.category))
        client.emit_failure t('jobs.cant_access_category')
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
      job.readers.each do |r| 
        if (r != job.author || notify_submitter)
          job.readers.delete r
        end
      end
      
      job.readers.add author

      Global.notifier.notify_ooc(:job_update, message) do |char|
        char && (Jobs.can_access_category?(char, job.category) || notify_submitter && char == job.author)
      end      
    end
  end
end