module AresMUSH
  module Jobs
    class JobsBackupCmd
      include Plugin
      include PluginRequiresLogin
           
      def want_command?(client, cmd)
        cmd.root_is?("jobs") && cmd.switch_is?("backup")
      end
      
      def check_too_many_jobs
        closed = Jobs.closed_jobs
        return t('jobs.too_much_for_backup') if closed.count > 30
        return t('jobs.no_closed_jobs') if closed.count == 0
        return nil
      end
    
      def handle
        client.emit_ooc t('jobs.starting_backup')
        Jobs.closed_jobs.each_with_index do |job, i|
          Global.dispatcher.queue_timer(i, "Job Backup #{client.char.name}") do
            Global.logger.debug "Logging job #{job.number} from #{client.char.name}."
            client.emit Jobs.get_job_display(client, job)
          end
        end
      end
    end
  end
end
