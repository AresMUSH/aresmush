module AresMUSH
  module Jobs
    class CharConnectedEventHandler
      def on_event(event)
        char = event.char
        client = event.client
        
        return if !Jobs.can_access_jobs?(char)
        
        Global.dispatcher.queue_timer(2, "Jobs", client) do 
          jobs = Jobs.filtered_jobs(char)
          paginator = Paginator.paginate(jobs, 1, 20)
          template = JobsListTemplate.new(char, paginator)
          client.emit template.render
        end
      end
    end
  end
end