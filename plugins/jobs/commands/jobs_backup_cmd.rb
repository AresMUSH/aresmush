module AresMUSH
  module Jobs
    class JobsBackupCmd
      include CommandHandler
      
      def check_too_many_jobs
        closed = Jobs.closed_jobs
        return t('jobs.no_closed_jobs') if closed.count == 0
        return nil
      end
    
      def handle
        client.emit_ooc t('jobs.starting_backup')
        closed_jobs = Jobs.closed_jobs
        closed_jobs.each_with_index do |job, i|
          Global.dispatcher.queue_timer(i, "Job Backup #{enactor.name}", client) do
            Global.logger.debug "Logging job #{job.id} from #{enactor.name}."
            template = JobTemplate.new(enactor, job)            
            client.emit template.render
          end
        end
        
        Global.dispatcher.queue_timer(closed_jobs.count + 2, "Jobs backup", client) do
          client.emit_success t('global.done')
        end
      end
    end
  end
end
