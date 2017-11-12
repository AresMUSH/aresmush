module AresMUSH
  module Jobs
    class CharConnectedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        client = event.client
        
        return if !Jobs.can_access_jobs?(char)
        
        Engine.dispatcher.queue_timer(2, "Jobs", client) do 
          jobs = Jobs.filtered_jobs(char)
          paginator = Paginator.paginate(jobs, 1, 20)
          template = JobsListTemplate.new(char, paginator)
          client.emit template.render
        end
      end
    end
  end
end