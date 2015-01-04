module AresMUSH
  module Jobs
    # Template for the list of all jobs.
    class JobsListTemplate
      include TemplateFormatters
      
      # List of jobs.
      # Usually you would use this in a list, like so:
      # Inside the loop, each job would be referenced as 'j'
      #    <% jobs.each do |j| -%>
      #    <%= job_num(j) %> <%= job_category(j) %>
      #    <% end %>
      attr_accessor :jobs
      
      def initialize(char, jobs, current_page, total_pages)
        @char = char
        @jobs = jobs
        @current_page = current_page
        @total_pages = total_pages
      end
      
      # Page x of y marker for the bottom of the screen.
      def page_marker
        page_marker = t('pages.page_x_of_y', :x => @current_page, :y => @total_pages)
        "%x!#{page_marker.center(78, '-')}%xn"
      end
      
      # Job number
      # Requires a job reference.  See 'jobs' for details.
      def job_num(job)
        right("#{job.number}", 5)
      end
      
      # Job category
      # Requires a job reference.  See 'jobs' for details.
      def job_category(job)
        left(job.category, 6)
      end
      
      # Job title
      # Requires a job reference.  See 'jobs' for details.
      def job_title(job)
        left(job.title, 18)
      end
      
      # Job handler
      # Requires a job reference.  See 'jobs' for details.
      def job_handler(job)
        name = job.assigned_to.nil? ? t('jobs.unhandled') : job.assigned_to.name
        left(name, 16)
      end
      
      # Job submitter
      # Requires a job reference.  See 'jobs' for details.
      def job_submitter(job)
        name = job.author.nil? ? t('jobs.deleted_author') : job.author.name
        left(name, 16)
      end
      
      # Job status
      # Requires a job reference.  See 'jobs' for details.
      def job_status(job)
        status = job.status
        color = Jobs.status_color(status)
        "#{color}#{left(status,6)}%xn"
      end
      
      # Job unread marker
      # Requires a job reference.  See 'jobs' for details.
      def job_unread_status(job)
        status = job.is_unread?(@char) ? t('jobs.unread_marker') : ""
        status = center(status, 3)
        " %xh#{status}%xn "
      end
    end
  end
end