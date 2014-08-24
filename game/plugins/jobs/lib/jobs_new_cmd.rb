module AresMUSH
  module Jobs
    class JobsNewCmd
      include Plugin
      include PluginWithoutArgs
    
      def want_command?(client, cmd)
        cmd.root_is?("jobs") && cmd.switch_is?("new")
      end
      
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
        client.emit Jobs.job_renderer.render(client, job)
        Jobs.mark_read(job, client.char)
      end
    end
  end
end
