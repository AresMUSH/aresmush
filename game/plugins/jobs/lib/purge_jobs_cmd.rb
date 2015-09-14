module AresMUSH
  module Jobs
    class PurgeJobsCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch_is?("purge")
      end
      
      def handle
        client.emit_failure t('jobs.confirm_purge')
      end
    end
    
    class PurgeJobsConfirmCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("jobs") && cmd.switch_is?("confirmpurge")
      end
      
      def check_closed_jobs
        return t('jobs.no_closed_jobs') if Jobs.closed_jobs.count == 0
        return nil
      end
      
      def handle
        Jobs.closed_jobs.each do |job|
          job.destroy
        end
        client.emit_success t('jobs.jobs_purged')
      end
    end
  end
end
