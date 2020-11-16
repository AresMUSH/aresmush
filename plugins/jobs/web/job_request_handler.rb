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
        job_admins = Character.all.select { |c| Jobs.can_access_job?(c, job) && c != system_char && c != master_admin }
        
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
          author: { name: job.author_name, id: job.author ? job.author.id : nil, icon: Website.icon_for_char(job.author) },
          assigned_to: job.assigned_to ? { name: job.assigned_to.name, icon: Website.icon_for_char(job.assigned_to) } : nil,
          description: Website.format_markdown_for_html(job.description),
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
          responses: (Global.read_config('jobs', 'responses') || []).map { |r| {
            name: r["name"],
            value: Website.format_input_for_html(r["text"])
          }}
        }
      end
    end
  end
end