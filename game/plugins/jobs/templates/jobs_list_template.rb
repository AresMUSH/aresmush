module AresMUSH
  module Jobs
    # Template for the list of all jobs.
    class JobsListTemplate < ErbTemplateRenderer
      
      attr_accessor :paginator
      
      def initialize(char, paginator)
        @char = char
        @paginator = paginator
        super File.dirname(__FILE__) + "/jobs_list.erb"
      end
      
      def status_color(job)
        Jobs.status_color(job.status)
      end
     
      def handler(job)
        !job.assigned_to ? t('jobs.unhandled') : job.assigned_to.name
      end
      
      def submitter(job)
        !job.author ? t('jobs.deleted_author') : job.author.name
      end
      
      def unread_status(job)
        job.is_unread?(@char) ? t('jobs.unread_marker') : ""
      end
      
      def jobs_footer
        page = " #{@paginator.page_marker} "
        filter = " #{t('jobs.job_filter_active', :filter => @char.jobs_filter)} "
        "#{center(filter, 34, '-')}#{center('', 10, '-')}#{center(page, 34, '-')}"
      end
    end
  end
end