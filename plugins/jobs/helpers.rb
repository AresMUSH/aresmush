module AresMUSH
  module Jobs    
      
    def self.can_access_jobs?(actor)
      actor && actor.has_permission?("access_jobs")
    end
    
    def self.can_manage_jobs?(actor)
      actor && actor.has_permission?("manage_jobs")
    end    
    
    def self.closed_jobs
      Job.all.select { |j| !j.is_open? }
    end
    
    def self.can_access_category?(actor, category)
      return false if !actor
      return true if actor.is_admin?
      return false if !Jobs.can_access_jobs?(actor)    
      actor.has_any_role?(category.roles)
    end

    def self.visible_replies(actor, job)
      if (Jobs.can_access_category?(actor, job.job_category))
        job.job_replies.to_a
      else
        job.job_replies.select { |r| !r.admin_only}
      end
    end
    
    def self.category_color(category_name)
      return "" if !(category_name)
      category = JobCategory.named(category_name)
      reutrn "%xh" if !category
      return category.color
    end
    
    def self.status_color(status)
      return "" if !status
      config = Global.read_config("jobs", "status")
      key = config.keys.find { |k| k.downcase == status.downcase }
      return "%xc" if !key
      return config[key]["color"]
    end
    
    def self.accessible_jobs(char, category_filter = nil, include_archive = false)
      jobs = []
      if (category_filter)
        categories = JobCategory.all.select{ |j| category_filter.include?(j.name) && Jobs.can_access_category?(char, j) }
      else
        categories = JobCategory.all.select{ |j| Jobs.can_access_category?(char, j) }
      end
      
      categories.each do |cat|
        if (include_archive)
          jobs = jobs.concat(cat.jobs.to_a)
        else
          active_statuses = Jobs.status_vals.select { |s| s != Jobs.archived_status }
          active_statuses.each do |status|
            jobs = jobs.concat(cat.jobs.find(status: status).to_a)
          end
        end
      end
      jobs
    end
    
    def self.status_filters
      base = [ "ACTIVE", "MINE", "UNREAD", "UNFINISHED", "UNASSIGNED", "ALL" ]
      status_filters = (Global.read_config("jobs", "status_filters") || {})
          .keys
          .map { |k| k.upcase }
      base.concat status_filters
    end
    
    def self.filtered_jobs(char, filter = nil)
      if (!filter)
        filter = char.jobs_filter
      end
            
      case filter
      when "ACTIVE"
        jobs = Jobs.accessible_jobs(char).select { |j| j.is_active? || j.is_unread?(char) }
      when "MINE"
        jobs = char.assigned_jobs.select { |j| j.is_open? }
      when "UNFINISHED"
        jobs = Jobs.accessible_jobs(char).select { |j| j.is_open? }
      when "UNASSIGNED"
        jobs = Jobs.accessible_jobs(char).select { |j| !j.assigned_to }
      when "UNREAD"
        jobs = char.unread_jobs
      when "ALL"
        jobs = Jobs.accessible_jobs(char)
      else 
        # Category or status filter
        if (Jobs.status_filters.include?(filter))
          statuses = Global.read_config("jobs", "status_filters")
                     .select { |k, v| k.upcase == filter.upcase }.values.first # This gives a list.
                     .map { |k| k.upcase }
          jobs = Jobs.accessible_jobs(char).select { |j| statuses.include?(j.status) }
        else
          jobs = Jobs.accessible_jobs(char, [ filter ]).select { |j| j.is_active? || j.is_unread?(char) }
        end
      end
        
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
      if (!job)
        client.emit_failure t('jobs.invalid_job_number')
        return
      end
      
      error = Jobs.check_job_access(enactor, job, true)
      if (error)
        client.emit_failure error
        return
      end
      
      
      yield job
    end
    
    def self.with_a_category(name, client, char, &block)
      category = JobCategory.named(name)
      if (!category)
        client.emit_failure t('jobs.invalid_category', :categories => Jobs.categories.join(", "))
        return
      end
      
      if !Jobs.can_access_category?(char, category)
        client.emit_failure t('jobs.cant_access_category')
        return
      end
      
      yield category
    end
    
    def self.comment(job, author, message, admin_only)
      reply = JobReply.create(:author => author, 
        :job => job,
        :admin_only => admin_only,
        :message => message)
        
      data = {
        job_id: job.id,
        reply_id: reply.id,
        admin_only: admin_only,
        author: { name: author.name, icon: Website.icon_for_char(author), id: author.id},
        message: Website.format_markdown_for_html(message),
        type: 'job_reply'
      }
      if (admin_only)
        notification = t('jobs.discussed_job', :name => author.name, :number => job.id, :title => job.title)
        Jobs.notify(job, notification, author, data, false, false)
      else
        notification = t('jobs.responded_to_job', :name => author.name, :number => job.id, :title => job.title)
        Jobs.notify(job, notification, author, data, true, false)
      end
    end
    
    def self.can_access_job?(enactor, job, allow_author = false)
      !Jobs.check_job_access(enactor, job, allow_author)
    end
    
    def self.check_job_access(enactor, job, allow_author = false)
      if (allow_author)
        return nil if enactor == job.author
        return nil if job.participants.include?(enactor)
      end
      return t('jobs.cant_view_job') if !Jobs.can_access_jobs?(enactor)
      return t('jobs.cant_access_category') if !Jobs.can_access_category?(enactor, job.job_category)
      return nil
    end
          
    def self.assign(job, assignee, enactor)
      job.update(assigned_to: assignee)
      job.update(status: Jobs.open_status)
      notification = t('jobs.job_assigned', :number => job.id, :title => job.title, :assigner => enactor.name, :assignee => assignee.name)
      Jobs.notify(job, notification, enactor)
    end
    
    def self.open_requests(char)
      char.requests.select { |r| r.is_open? || r.is_unread?(char) }
    end
    
    def self.closed_statuses
      Global.read_config("jobs", "closed_statuses")
    end
    
    def self.active_statuses
      Global.read_config("jobs", "active_statuses")
    end
    
    def self.archived_status
      Global.read_config("jobs", "archived_status")
    end
    
    def self.open_status
      Global.read_config("jobs", "open_status")
    end
        
    def self.notify(job, message, author, data = nil, notify_participants = true, add_to_job = true)
      
      if (add_to_job)
        JobReply.create(:author => author, 
          :job => job,
          :admin_only => false,
          :message => message)
      end
      
      Jobs.mark_unread(job)
      Jobs.mark_read(job, author)
      
      all_parties = job.all_parties
      
      data = "#{job.id}|#{message}|#{data.to_json}"
      Global.client_monitor.notify_web_clients(:job_update, data, true) do |char|
        char && (Jobs.can_access_category?(char, job.job_category) || notify_participants && all_parties.include?(char))
      end
      
      Global.notifier.notify_ooc(:job_message, message) do |char|
        char && (Jobs.can_access_category?(char, job.job_category) || notify_participants && all_parties.include?(char))
      end
            
      job.all_parties.each do |p|
        
        # If they can't see the change, don't send them a notification.
        # Also mark it read so it doesn't show up on their unread list unnecessarily.
        if (!notify_participants && !Jobs.can_access_category?(p, job.job_category))
          Jobs.mark_read(job, p)
          next
        end
        
        # No need for notification if you did it.
        next if p == author
        Login.notify(p, :job, t('jobs.new_job_activity', :num => job.id), job.id)
      end
    end    
    
    def self.reboot_required_notice
      Manage.server_reboot_required? ? t('jobs.reboot_required') : nil
    end

    def self.change_job_title(enactor, job, title)
      job.update(title: title)
      notification = t('jobs.updated_job_title', :number => job.id, :title => job.title, :name => enactor.name)
      Jobs.notify(job, notification, enactor)
    end
        
    def self.change_job_category(enactor, job, category_name)
      category = JobCategory.named(category_name)
      job.update(job_category: category)
      notification = t('jobs.updated_job_category', :number => job.id, :title => job.title, :name => enactor.name)
      Jobs.notify(job, notification, enactor)
    end
    
    def self.check_filter_type(filter)
      types = Jobs.categories.concat(Jobs.status_filters)
      return t('jobs.invalid_filter_type', :names => types) if !types.include?(filter)
      return nil
    end
    
    def self.mark_read(job, char)  
      tracker = char.get_or_create_read_tracker 
      tracker.mark_job_read(job)   
      Login.mark_notices_read(char, :job, job.id)
    end
    
    def self.mark_unread(job)
      chars = Character.all.select { |c| !Jobs.is_unread?(job, c) }
      chars.each do |char|
        tracker = char.get_or_create_read_tracker
        tracker.mark_job_unread(job)
      end
    end
    
    def self.is_unread?(job, char)
      tracker = char.get_or_create_read_tracker
      tracker.is_job_unread?(job)
    end
    
    def self.has_participant_by_name?(job, name)
      name_upcase = "#{name}".upcase
      return true if job.author && (job.author.name.upcase == name_upcase)
      return true if job.assigned_to && job.assigned_to.name_upcase == name_upcase
      return true if job.participants.any? { |p| p.name.upcase == name_upcase }
      return false
    end
    
  end
end