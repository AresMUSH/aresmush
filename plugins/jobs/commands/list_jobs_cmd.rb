module AresMUSH
  module Jobs
    class ListJobsCmd
      include CommandHandler
      

      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        jobs =  Jobs.filtered_jobs(enactor)
        paginator = Paginator.paginate(jobs, cmd.page, 20)
        filter = enactor.jobs_filter
        template = JobsListTemplate.new(enactor, paginator, filter)
        client.emit template.render
      end
    end
  end
end
