module AresMUSH
  module Jobs
    class CreateRequestCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :title, :description
      
      def initialize
        self.required_args = ['title', 'description']
        self.help_topic = 'requests'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("request") && cmd.switch.nil? && cmd.args =~ /\=/
      end
      
      def crack!
        cmd.crack!(CommonCracks.arg1_equals_arg2)
        self.title = trim_input(cmd.args.arg1)
        self.description = cmd.args.arg2
      end
      
      def handle
        result = Jobs.create_job("REQ", self.title, self.description, client.char)
        if (result[:error].nil?)
          client.emit_success t('jobs.request_submitted')
        else
          client.emit_failure result[:error]
        end
      end
    end
  end
end
