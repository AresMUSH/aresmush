module AresMUSH
  module Jobs
    class ViewJobCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      include SingleJobCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch.nil?
      end
      
      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          client.emit Jobs.job_renderer.render(client, job)
        end
      end
    end
  end
end
