module AresMUSH
  module Jobs
    class CreateJobCmd
      include CommandHandler

      attr_accessor :title, :description, :category
      
      def parse_args
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          
          self.title = trim_arg(args.arg1) || cmd.args
          self.category = upcase_arg(args.arg2) || Jobs.request_category
          self.description = args.arg3 || "---"
      end
      
      def required_args
        [ self.title, self.description, self.category ]
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        result = Jobs.create_job(self.category, self.title, self.description, enactor)
        if (!result[:error].nil?)
          client.emit_failure result[:error]
        else
          client.emit_success t('jobs.job_created')
        end
      end
    end
  end
end
