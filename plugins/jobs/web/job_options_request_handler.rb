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
        
        custom_fields = (Global.read_config("jobs", "custom_fields") || [])
           .map { |field| [ Jobs.custom_field_id(field['name']), field ] }.to_h
        
        {
          status_values: Jobs.status_vals,
          category_values: Jobs.categories,
          status_filters: Jobs.status_filters,
          category_templates: category_templates,
          request_category: Jobs.request_category,
          custom_fields: custom_fields,
          date_entry_format: Global.read_config("datetime", 'date_entry_format_help').upcase,
          is_job_admin: is_job_admin,
          reboot_required_notice: Website.format_markdown_for_html(Jobs.reboot_required_notice)
        }
      end
    end
  end
end