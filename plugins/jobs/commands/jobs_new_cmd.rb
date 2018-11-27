module AresMUSH
  module Jobs
    class JobsNewCmd
      include CommandHandler
    
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        unread = enactor.unread_jobs
        if (unread.empty?)
          client.emit_success t('jobs.no_new_jobs')
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
