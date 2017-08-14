module AresMUSH
  module Jobs
    class JobsCatchupCmd
      include CommandHandler
      
      def help
        "`jobs/catchup` - Marks all jobs as read."
      end
      
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
        
        unread.each do |job|
          Jobs.mark_read(job, enactor)
        end
        client.emit_success t('jobs.jobs_caught_up')
      end
    end
  end
end
