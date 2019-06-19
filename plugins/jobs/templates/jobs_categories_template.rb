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
        roles = [ t('jobs.job_admin_only') ]
        roles.concat cat.roles.map { |r| r.name.titlecase }
        roles.join(", ")
      end     
      
      def category_color(cat)
        Jobs.category_color(cat.name)
      end
      
      def can_access_category?(cat)
        Jobs.can_access_category?(@enactor, cat)
      end
      
      def reboot_text
        Jobs.reboot_required_notice
      end
    end
  end
end