module AresMUSH
  module Jobs
    class CreateRequestCmd
      include CommandHandler

      attr_accessor :title, :description

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.title = trim_arg(args.arg1)
        self.description = args.arg2
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
