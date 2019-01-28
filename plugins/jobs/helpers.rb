module AresMUSH
  module Jobs    
      
    def self.can_access_jobs?(actor)
      return false if !actor
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
        jobs = Job.all.select { |j| Jobs.can_access_category?(char, j.category) }
      when "UNFINISHED", nil
        jobs = Job.all.select { |j| Jobs.can_access_category?(char, j.category) && (j.is_open? || j.is_unread?(char)) }
      when "ACTIVE", nil
        jobs = Job.all.select { |j| Jobs.can_access_category?(char, j.category) && (j.is_active? || j.is_unread?(char)) }
      when "MINE"
        jobs = char.assigned_jobs.select { |j| j.is_open? }
      else
        jobs = Job.find(category: char.jobs_filter.upcase).select { |j| Jobs.can_access_category?(char, j.category) && j.is_open? }
      end

      jobs = jobs || []
      jobs.sort_by { |j| j.created_at }
    end
    
    def self.with_a_job(char, client, number, &block)
      job = Job[number]
      if (!job)
        client.emit_failure t('jobs.invalid_job_number')
        return
      end
      
      error = Jobs.check_job_access(char, job)
      if (error)
        client.emit_failure error
        return
      end
      
      yield job
    end
    
    def self.with_a_request(client, enactor, number, &block)
      job = Job[number]
      if (!job || job.author != enactor)
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
        notification = t('jobs.discussed_job', :name => author.name, :number => job.id, :title => job.title)
        Jobs.notify(job, notification, author, false)
      else
        notification = t('jobs.responded_to_job', :name => author.name, :number => job.id, :title => job.title)
        Jobs.notify(job, notification, author)
      end
    end
    
    def self.can_access_job?(enactor, job)
      !Jobs.check_job_access(enactor, job)
    end
    
    def self.check_job_access(enactor, job, allow_author = false)
      if (allow_author)
        return nil if enactor == job.author
      end
      return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
      return t('jobs.cant_access_category') if !Jobs.can_access_category?(enactor, job.category)
      return nil
    end
          
    def self.assign(job, assignee, enactor)
      job.update(assigned_to: assignee)
      job.update(status: "OPEN")
      notification = t('jobs.job_assigned', :number => job.id, :title => job.title, :assigner => enactor.name, :assignee => assignee.name)
      Jobs.notify(job, notification, enactor)
    end
    
    def self.mark_read(job, char)      
      job.readers.add char
    end
    
    def self.open_requests(char)
      char.jobs.select { |r| r.is_open? || r.is_unread?(char) }
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
    
    def self.reboot_required_notice
      File.exist?('/var/run/reboot-required') ? t('jobs.reboot_required') : nil
    end

    def self.change_job_title(enactor, job, title)
      job.update(title: title)
      notification = t('jobs.updated_job', :number => job.id, :title => job.title, :name => enactor.name)
      Jobs.notify(job, notification, enactor)
    end
        
    def self.change_job_category(enactor, job, category)
      job.update(category: category)
      notification = t('jobs.updated_job', :number => job.id, :title => job.title, :name => enactor.name)
      Jobs.notify(job, notification, enactor)
    end
    
    def self.check_filter_type(filter)
      types = ["ACTIVE", "MINE", "ALL", "UNFINISHED"].concat(Jobs.categories)
      return t('jobs.invalid_filter_type', :names => types) if !types.include?(filter)
      return nil
    end
  end
end