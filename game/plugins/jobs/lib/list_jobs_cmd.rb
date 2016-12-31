module AresMUSH
  module Jobs
    class ListJobsCmd
      include CommandHandler
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        jobs = cmd.switch_is?("all") ? 
          Job.all.to_a : 
          Job.all.select { |j| j.is_open? || j.is_unread?(enactor) }
  
        jobs = jobs.sort_by { |j| j.number }
        paginator = Paginator.paginate(jobs, cmd.page, 20)
        if (paginator.out_of_bounds?)
          client.emit BorderedDisplay.text(t('pages.not_that_many_pages'))
        else
          template = JobsListTemplate.new(enactor, paginator)
          client.emit template.render
        end
      end
    end
  end
end
