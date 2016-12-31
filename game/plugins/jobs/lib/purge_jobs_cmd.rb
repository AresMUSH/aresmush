module AresMUSH
  module Jobs
    class PurgeJobsCmd
      include CommandHandler
      
      def handle
        client.emit_failure t('jobs.confirm_purge')
      end
    end
    
    class PurgeJobsConfirmCmd
      include CommandHandler
      
      def check_closed_jobs
        return t('jobs.no_closed_jobs') if Jobs.closed_jobs.count == 0
        return nil
      end
      
      def handle
        Jobs.closed_jobs.each do |job|
          job.delete
        end
        client.emit_success t('jobs.jobs_purged')
      end
    end
  end
end
