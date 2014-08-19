module AresMUSH
  module Jobs
    class ListJobsCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs

      def want_command?(client, cmd)
        cmd.root_is?("jobs")
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(client.char)
        return nil
      end
      
      def handle
        jobs = cmd.switch_is?("all") ? 
          Job.all : 
          Job.all.select { |j| j.is_open? }

        jobs = jobs.sort_by { |j| j.number }
        client.emit Jobs.jobs_list_renderer.render(client, jobs)
      end
    end
  end
end
