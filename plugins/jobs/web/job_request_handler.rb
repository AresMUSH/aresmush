module AresMUSH
  module Jobs
    class JobRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        edit_mode = (request.args[:edit_mode] || "").to_bool
        
        error = Website.check_login(request)
        return error if error

        if (!job)
          return { error: t('webportal.not_found') }
        end
        
        is_job_admin = Jobs.can_access_jobs?(enactor)
        
        if (edit_mode && !is_job_admin)
          return { error: t('dispatcher.not_allowed') }
        end
        
        # Authors can access their own job.
        error = Jobs.check_job_access(enactor, job, true)
        if (error)
          return { error: error }
        end
        
        Jobs.mark_read(job, enactor)
        
        system_char = Game.master.system_character
        master_admin = Game.master.master_admin
        job_admins = Character.all.select { |c| Jobs.can_access_job?(c, job) && c != system_char && c != master_admin }
        
        description = edit_mode ? job.description : Website.format_markdown_for_html(job.description)
        roster_char = Character.all.select { |c| c.roster_job == job }.first
          
        {
          id: job.id,
          title: job.title,
          unread: job.is_unread?(enactor),
          category: job.job_category.name,
          status: job.status,
          created: job.created_date_str(enactor),
          is_open: job.is_open?,
          is_job_admin: is_job_admin,
          fs3_enabled: FS3Skills.is_enabled?,
          is_category_admin: Jobs.can_access_category?(enactor, job.job_category),
          is_approval_job: job.author && !job.author.is_approved? && (job.author.approval_job == job),
          is_roster_job: roster_char && job.is_open?,
          roster_name: roster_char ? roster_char.name : nil,
          author: { name: job.author_name, id: job.author ? job.author.id : nil, icon: Website.icon_for_char(job.author) },
          assigned_to: job.assigned_to ? { name: job.assigned_to.name, icon: Website.icon_for_char(job.assigned_to) } : nil,
          description: description,
          tags: job.content_tags,
          unread_jobs_count: is_job_admin ? enactor.unread_jobs.count : enactor.unread_requests.count,
          replies: Jobs.visible_replies(enactor, job).map { |r| {
            author: { name: r.author_name, icon: Website.icon_for_char(r.author) },
            message: Website.format_markdown_for_html(r.message),
            created: r.created_date_str(enactor),
            admin_only: r.admin_only,
            id: r.id
          }},
          participants: job.participants.map { |p| {
            name: p.name,
            icon: Website.icon_for_char(p),
            id: p.id
          }},
          job_admins: job_admins.map { |c|  { 
            id: c.id, 
            name: c.name 
            }},
          responses: Jobs.preset_job_responses_for_web,
          custom: Jobs.custom_job_menu_fields(job, enactor)
        }
      end
    end
  end
end