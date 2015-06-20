module AresMUSH
  module Jobs
    # Template for the list of all jobs.
    class JobsListTemplate
      include TemplateFormatters
      
      attr_accessor :jobs
      
      def initialize(char, jobs, current_page, total_pages)
        @char = char
        @jobs = jobs
        @current_page = current_page
        @total_pages = total_pages
      end
      
      def display
        text = "%l1%r"
        text << "%xh#{t('jobs.jobs_list_title')}%xn%r"
        text << "%l2"
        jobs.each do |j|
          text << "%r"
          text << job_num(j)
          text << " "
          text << job_unread_status(j)
          text << " "
          text << job_status(j)
          text << " "
          text << job_title(j)
          text << " "
          text << job_submitter(j)
          text << " "
          text << job_handler(j)
          text << " "
          text << job_category(j)
        end
        
        text << "%r#{page_marker}"
        text << "%r%l1"
        
        text
      end
      
        
      # Page x of y marker for the bottom of the screen.
      def page_marker
        page_marker = t('pages.page_x_of_y', :x => @current_page, :y => @total_pages)
        "%x!#{page_marker.center(78, '-')}%xn"
      end
      
      def job_num(job)
        right("#{job.number}", 5)
      end
      
      def job_category(job)
        left(job.category, 6)
      end
      
      def job_title(job)
        left(job.title, 18)
      end
      
      def job_handler(job)
        name = job.assigned_to.nil? ? t('jobs.unhandled') : job.assigned_to.name
        left(name, 16)
      end
      
      def job_submitter(job)
        name = job.author.nil? ? t('jobs.deleted_author') : job.author.name
        left(name, 16)
      end
      
      def job_status(job)
        status = job.status
        color = Jobs.status_color(status)
        "#{color}#{left(status,6)}%xn"
      end
      
      def job_unread_status(job)
        status = job.is_unread?(@char) ? t('jobs.unread_marker') : ""
        status = center(status, 3)
        " %xh#{status}%xn "
      end
    end
  end
end