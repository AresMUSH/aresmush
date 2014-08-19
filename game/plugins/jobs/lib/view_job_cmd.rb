module AresMUSH
  module Jobs
    class ViewJobCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :number
      
      def initialize
        self.required_args = ['number']
        self.help_topic = 'jobs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch.nil?
      end
      
      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(client.char)
        return nil
      end
      
      def check_number
        return nil if self.number.nil?
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          client.emit Jobs.job_renderer.render(client, job)
        end
      end
    end
  end
end
