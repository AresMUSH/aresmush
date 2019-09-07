module AresMUSH
  module Jobs
    class JobOptionsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        is_job_admin = Jobs.can_access_jobs?(enactor)
        
        category_templates = {}
        JobCategory.all.each do |cat|
          if (cat.template)
            category_templates[cat.name]  = Website.format_input_for_html(cat.template)
          end
        end
        
        {
          status_values: Jobs.status_vals,
          category_values: Jobs.categories,
          category_templates: category_templates,
          request_category: Jobs.request_category,
          is_job_admin: is_job_admin,
          reboot_required_notice: Jobs.reboot_required_notice
        }
      end
    end
  end
end