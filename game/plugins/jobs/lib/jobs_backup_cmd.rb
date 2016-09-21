module AresMUSH
  module Jobs
    class JobsBackupCmd
      include CommandHandler
      include CommandRequiresLogin

      def check_too_many_jobs
        closed = Jobs.closed_jobs
        return t('jobs.too_much_for_backup') if closed.count > 30
        return t('jobs.no_closed_jobs') if closed.count == 0
        return nil
      end
    
      def handle
        client.emit_ooc t('jobs.starting_backup')
        Jobs.closed_jobs.each_with_index do |job, i|
          Global.dispatcher.queue_timer(i, "Job Backup #{client.char.name}", client) do
            Global.logger.debug "Logging job #{job.number} from #{client.char.name}."
            client.emit Jobs.get_job_display(client, job)
          end
        end
      end
    end
  end
end
