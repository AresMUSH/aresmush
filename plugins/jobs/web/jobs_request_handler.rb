module AresMUSH
  module Jobs
    class JobsRequestHandler
      def handle(request)
        page = (request.args[:page] || "1").to_i
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        job_admin = Jobs.can_access_jobs?(enactor)
        if (job_admin)
          jobs = Jobs.filtered_jobs(enactor)
        else 
          jobs = []
        end
        
        filter = enactor.jobs_filter || "ACTIVE"
        case filter
          
        when "MINE", "UNFINISHED"
          jobs.concat Jobs.open_requests(enactor)
        when "ACTIVE"
          jobs.concat Jobs.open_requests(enactor).select { |j| j.is_active? }
        when "UNREAD"
          jobs.concat enactor.unread_requests
        when "ALL"
          jobs.concat enactor.requests.to_a 
        else # Category filter
          jobs.concat Jobs.open_requests(enactor).select { |j| j.job_category.name == enactor.jobs_filter}
        end
        
        jobs = jobs.uniq.sort_by { |j| j.created_at }.reverse
        
        paginator = Paginator.paginate(jobs, page, 30)
        
        if (paginator.out_of_bounds?)
          return { jobs: [], pages: [1], jobs_filter: filter }
        end
        
        {
          jobs_filter: filter,
          jobs: paginator.page_items.map { |j| {
            id: j.id,
            title: j.title,
            unread: j.is_unread?(enactor),
            created: j.created_date_str(enactor),
            category: j.job_category.name,
            status: j.status,
            author: j.author_name,
            assigned_to: j.assigned_to ? j.assigned_to.name : "--"
          }},
          pages: paginator.total_pages.times.to_a.map { |i| i+1 }
        } 
      end
    end
  end
end