module AresMUSH
  module Jobs
    class JobsNewCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
    
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(client.char)
        return nil
      end
      
      def handle
        unread = client.char.unread_jobs
        if (unread.empty?)
          client.emit_success t('jobs.no_new_jobs')
          return
        end
        
        unread = unread.sort_by { |j| j.number }
        job = unread[0]
        client.emit Jobs.get_job_display(client, job)
        Jobs.mark_read(job, client.char)
      end
    end
  end
end
