module AresMUSH
  module Jobs
    class DeleteJobCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      include SingleJobCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch_is?("delete")
      end
      
      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          job.destroy
          Jobs.notify(job, t('jobs.job_deleted', :title => job.title, :name => client.name))
        end
      end
    end
  end
end
