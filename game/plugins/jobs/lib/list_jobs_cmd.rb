module AresMUSH
  module Jobs
    class ListJobsCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs

      attr_accessor :page
      
      def crack!
        self.page = !cmd.page ? 1 : trim_input(cmd.page).to_i
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        jobs = cmd.switch_is?("all") ? 
          Job.all : 
          Job.all.select { |j| j.is_open? || j.is_unread?(enactor) }
          #Job.or( { :status.ne => "DONE" }, {:readers.nin => [enactor.id]} )
          #Job.includes(:readers).where("reader._id" => enactor.id )
  
        jobs = jobs.sort_by { |j| j.number }
        paginator = Paginator.paginate(jobs, self.page, 20)
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
