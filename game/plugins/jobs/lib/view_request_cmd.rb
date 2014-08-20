module AresMUSH
  module Jobs
    class ViewRequestCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :number
      
      def initialize
        self.required_args = ['number']
        self.help_topic = 'requests'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("request") && cmd.switch.nil? && cmd.args !~ /\=/
      end
      
      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def check_number
        return nil if self.number.nil?
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def handle
        Jobs.with_a_request(client, self.number) do |request|
          client.emit Jobs.job_renderer.render(client, request)
          Jobs.mark_read(request, client.char)
        end
      end
    end
  end
end
