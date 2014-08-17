module AresMUSH
  module Jobs
    class JobsListTemplate
      include TemplateFormatters
      
      attr_accessor :jobs
      
      def initialize(char, jobs)
        @char = char
        @jobs = jobs
      end
      
      def job_num(job)
        right("#{job.number}", 5)
      end
      
      def job_category(job)
        left(job.category, 6)
      end
      
      def job_title(job)
        left(job.title,21)
      end
      
      def job_handler(job)
        name = job.author.nil? ? t('jobs.unhandled') : job.author.name
        left(name, 17)
      end
      
      def job_submitter(job)
        name = job.author.nil? ? t('jobs.deleted_author') : job.author.name
        left(name, 17)
      end
      
      def job_status(job)
        status = job.status
        color = Jobs.status_color(status)
        "#{color}#{left(status,6)}%xn"
      end
      
      def job_unread_status(job)
        # TODO - unread status
        "%xB#{t('jobs.unread_marker')}%xn"
      end
    end
  end
end