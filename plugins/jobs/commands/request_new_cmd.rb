module AresMUSH
  module Jobs
    class RequestNewCmd
      include CommandHandler
    
      def handle
        unread = enactor.unread_requests
        if (unread.empty?)
          client.emit_success t('jobs.no_new_requests')
          return
        end
        
        unread = unread.sort_by { |j| j.created_at }
        job = unread[0]
        template = JobTemplate.new(enactor, job)            
        client.emit template.render
        Jobs.mark_read(job, enactor)
      end
    end
  end
end
