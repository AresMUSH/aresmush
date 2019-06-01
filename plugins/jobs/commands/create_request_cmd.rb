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
        [ self.title, self.description ]
      end
      
      def handle
        
        if self.title.to_i != 0
          client.emit_failure t('jobs.request_use_respond')
          return
        end
        
        if (!enactor.is_approved? && enactor.requests.select { |j| j.is_open? }.count >= 5)
          client.emit_failure t('jobs.too_many_jobs_open')
          return
        end
        
        result = Jobs.create_job(Jobs.request_category, self.title, self.description, enactor)
        if (result[:error].nil?)
          client.emit_success t('jobs.request_submitted')
        else
          client.emit_failure result[:error]
        end
      end
    end
  end
end
