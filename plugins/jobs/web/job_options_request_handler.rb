module AresMUSH
  module Jobs
    class JobOptionsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        is_job_admin = Jobs.can_access_jobs?(enactor)
        
        {
          status_values: Jobs.status_vals,
          category_values: Jobs.categories,
          request_category: Jobs.request_category,
          is_job_admin: is_job_admin,
          reboot_required_notice: Jobs.reboot_required_notice,
          jobs_filter: enactor.jobs_filter
        }
      end
    end
  end
end