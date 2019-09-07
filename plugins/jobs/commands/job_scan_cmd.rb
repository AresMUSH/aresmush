module AresMUSH
  module Jobs
    class JobScanCmd
      include CommandHandler
      
      def check_can_access
        return t('jobs.cant_access_jobs') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        unread = enactor.unread_jobs
        if (unread.empty?)
          client.emit_success t('jobs.no_new_jobs')
          return
        end
        
        client.emit_ooc t('jobs.scan_summary', :count => unread.count)
      end
    end
  end
end