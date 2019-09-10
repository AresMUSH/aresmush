module AresMUSH
  module Jobs
    class JobsCatchupCmd
      include CommandHandler
      
      attr_accessor :number
      
      def parse_args
        self.number = integer_arg(cmd.args)
      end
      
      def check_can_access
        return t('jobs.cant_access_jobs') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        
        if (self.number)
          job = Job[self.number]
          if (!job)
            client.emit_failure t('jobs.invalid_job_number')
            return
          end
          unread = [ job ]
        else
          unread = enactor.unread_jobs
          if (unread.empty?)
            client.emit_success t('jobs.no_new_jobs')
            return
          end
        end
        
        unread.each do |job|
          Jobs.mark_read(job, enactor)
        end
        client.emit_success t('jobs.jobs_caught_up')
      end
    end
  end
end
