module AresMUSH
  module Jobs
    class JobRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        
        error = Website.check_login(request)
        return error if error

        if (!job)
          return { error: t('webportal.not_found') }
        end
        
        is_job_admin = Jobs.can_access_jobs?(enactor)
        
        # Authors can access their own job.
        error = Jobs.check_job_access(enactor, job, true)
        if (error)
          return { error: error }
        end
        
        Jobs.mark_read(job, enactor)
        
        system_char = Game.master.system_character
        master_admin = Game.master.master_admin
        job_admin = Character.all.select { |c| Jobs.can_access_job?(c, job) && c != system_char && c != master_admin }
        
        {
          id: job.id,
          title: job.title,
          unread: job.is_unread?(enactor),
          category: job.category,
          status: job.status,
          created: job.created_date_str(enactor),
          is_open: job.is_open?,
          is_job_admin: is_job_admin,
          is_approval_job: job.author && !job.author.is_approved? && (job.author.approval_job == job),
          author: { name: job.author_name, id: job.author ? job.author.id : nil, icon: Website.icon_for_char(job.author) },
          assigned_to: job.assigned_to ? { name: job.assigned_to.name, icon: Website.icon_for_char(job.assigned_to) } : nil,
          description: Website.format_markdown_for_html(job.description),
          status_values: Jobs.status_vals,
          job_admin: job_admin.map { |c|  { 
            id: c.id, 
            name: c.name 
            }},
          replies: Jobs.visible_replies(enactor, job).map { |r| {
            author: { name: r.author_name, icon: Website.icon_for_char(r.author) },
            message: Website.format_markdown_for_html(r.message),
            created: r.created_date_str(enactor),
            admin_only: r.admin_only
          }}
        }
      end
    end
  end
end