module AresMUSH
  module Jobs
    class ListRequestsCmd
      include CommandHandler

      def handle
        
        requests = enactor.jobs_filter == "ALL" ?
          enactor.requests.to_a : 
          Jobs.open_requests(enactor)

        requests = requests.sort_by { |r| r.created_at }
        paginator = Paginator.paginate(requests, cmd.page, 20)
        if (paginator.out_of_bounds?)
          template = BorderedDisplayTemplate.new t('pages.not_that_many_pages')
          client.emit template.render
        else
          template = JobsListTemplate.new(enactor, paginator, t('jobs.request_filter_tip'))
          client.emit template.render
        end
      end
    end
  end
end
