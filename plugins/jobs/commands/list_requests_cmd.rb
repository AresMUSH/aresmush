module AresMUSH
  module Jobs
    class ListRequestsCmd
      include CommandHandler

      def handle
        requests = cmd.switch_is?("all") ? 
          enactor.jobs.to_a : 
          Jobs.open_requests(enactor)

        requests = requests.sort_by { |r| r.created_at }
        paginator = Paginator.paginate(requests, cmd.page, 20)
        if (paginator.out_of_bounds?)
          template = BorderedDisplayTemplate.new t('pages.not_that_many_pages')
          client.emit template.render
        else
          template = JobsListTemplate.new(enactor, paginator)
          client.emit template.render
        end
      end
    end
  end
end
