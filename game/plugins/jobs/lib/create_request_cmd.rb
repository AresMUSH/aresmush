module AresMUSH
  module Jobs
    class CreateRequestCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs

      attr_accessor :title, :description

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.title = trim_input(cmd.args.arg1)
        self.description = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.title, self.description ],
          help: 'requests'
        }
      end
      
      def handle
        result = Jobs.create_job("REQ", self.title, self.description, enactor)
        if (result[:error].nil?)
          client.emit_success t('jobs.request_submitted')
        else
          client.emit_failure result[:error]
        end
      end
    end
  end
end
