module AresMUSH
  module Jobs
    class ListJobsCmd
      include CommandHandler
      
      attr_accessor :show_all
      
      def parse_args
        self.show_all = cmd.switch_is?("all")
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        jobs = self.show_all ? Job.all.to_a : Jobs.filtered_jobs(enactor)
        paginator = Paginator.paginate(jobs, cmd.page, 20)
        filter = self.show_all ? "ALL" : enactor.jobs_filter
        template = JobsListTemplate.new(enactor, paginator, filter)
        client.emit template.render
      end
    end
  end
end
