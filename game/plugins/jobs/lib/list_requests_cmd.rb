module AresMUSH
  module Jobs
    class ListRequestsCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs

      attr_accessor :page
      
      def crack!
        self.page = !cmd.page ? 1 : trim_input(cmd.page).to_i
      end
      
      def handle
        requests = cmd.switch_is?("all") ? 
          enactor.jobs.to_a : 
          enactor.jobs.select { |r| r.is_open? || r.is_unread?(enactor) }

        requests = requests.sort_by { |r| r.number }
        paginator = Paginator.paginate(requests, self.page, 20)
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
