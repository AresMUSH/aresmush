module AresMUSH
  module Jobs
    class JobCategoriesListTemplate < ErbTemplateRenderer
      
      attr_accessor :enactor
      
      def initialize(enactor)
        @enactor = enactor
        super File.dirname(__FILE__) + "/jobs_categories.erb"
      end
      
      def categories
        JobCategory.all.to_a.sort_by { |j| j.name }
      end
      
      def roles(cat)
        if (cat.roles.empty?)
          read_roles = t('jobs.job_admin_only')
        else 
          read_roles = cat.roles.map { |r| r.name.titlecase }.join(", ")
        end
      end     
      
      
      def can_access_category?(cat)
        if (cat.roles.empty?)
          return @enactor.is_admin?
        end
        @enactor.has_any_role?(cat.roles)
      end
      
      def reboot_text
        Jobs.reboot_required_notice
      end
    end
  end
end