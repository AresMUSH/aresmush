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
          jobs = Jobs.filtered_jobs(enactor)
        else
          jobs = []
        end

        jobs.concat Jobs.open_requests(enactor)
        jobs = jobs.uniq.sort_by { |j| j.created_at }.reverse

        jobs.map { |j| {
            id: j.id,
            title: j.title,
            unread: j.is_unread?(enactor),
            created: j.created_date_str(enactor),
            category: j.category,
            status: j.status,
            author: j.author_name,
            assigned_to: j.assigned_to ? j.assigned_to.name : "--"
          }}
      end
    end
  end
end
