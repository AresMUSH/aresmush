module AresMUSH
  module Jobs
    # Template for the list of all jobs.
    class JobsListTemplate < ErbTemplateRenderer
      
      attr_accessor :paginator, :tip
      
      def initialize(char, paginator, tip, filter = nil)
        @char = char
        @paginator = paginator
        @filter = filter || @char.jobs_filter
        @tip = tip
        super File.dirname(__FILE__) + "/jobs_list.erb"
      end
      
      def status_color(job)
        Jobs.status_color(job.status)
      end
      
      def category_color(job)
        Jobs.category_color(job.job_category.name)
      end
     
      def handler(job)
        !job.assigned_to ? t('jobs.unhandled') : job.assigned_to.name
      end
      
      def submitter(job)
        !job.author ? t('global.deleted_character') : job.author.name
      end
      
      def unread_status(job)
        job.is_unread?(@char) ? t('jobs.unread_marker') : ""
      end
      
      def reboot_text
        Jobs.reboot_required_notice
      end
      
      def jobs_footer
        page = " #{@paginator.page_marker} "
        filter = " #{t('jobs.job_filter_active', :filter => @filter)} "
        "#{center(filter, 34, '-')}#{center('', 10, '-')}#{center(page, 34, '-')}"
      end
    end
  end
end