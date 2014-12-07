module AresMUSH
  module Jobs
    mattr_accessor :jobs_list_renderer, :job_renderer
        
    def self.build_renderers
        self.jobs_list_renderer = JobsListRenderer.new
        self.job_renderer = JobRenderer.new
    end
    
    class JobsListRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/jobs_list.erb")
      end

      def render(client, jobs, current_page, total_pages)
        data = JobsListTemplate.new(client.char, jobs, current_page, total_pages)
        @renderer.render(data)
      end
    end
    
    class JobRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/job.erb")
      end

      def render(client, job)
        replies = Jobs.can_access_jobs?(client.char) ? job.job_replies : job.job_replies.select { |r| !r.admin_only}
        data = JobTemplate.new(client, job, replies)
        @renderer.render(data)
      end
    end
  end
end