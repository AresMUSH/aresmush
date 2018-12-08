module AresMUSH
  module Jobs
    class JobsRequestHandler
      def handle(request)
        topic = request.args[:topic]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        job_admin = Jobs.can_access_jobs?(enactor)
        if (job_admin)
          jobs = Jobs.filtered_jobs(enactor, "ACTIVE").sort_by { |j| j.created_at }.reverse
        else
          jobs = Jobs.open_requests(enactor).sort_by { |j| j.created_at }.reverse
        end
        
        { 
          jobs: jobs.map { |j| {
            id: j.id,
            title: j.title,
            unread: j.is_unread?(enactor),
            created: j.created_date_str(enactor),
            category: j.category,
            status: j.status,
            author: j.author_name,
            assigned_to: j.assigned_to ? j.assigned_to.name : "--"
          }},
          reboot_required_notice: Jobs.reboot_required_notice,
          job_admin: job_admin
        }
        
      end
    end
  end
end