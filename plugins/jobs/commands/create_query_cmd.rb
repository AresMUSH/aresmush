module AresMUSH
  module Jobs
    class CreateQueryJobCmd
      include CommandHandler

      attr_accessor :target, :title, :description
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.target = titlecase_arg(args.arg1)
        self.title = trim_arg(args.arg2)
        self.description = args.arg3
      end
      
      def required_args
        [ self.title, self.description, self.target ]
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          message = t('jobs.job_query', :name => enactor_name, :target => model.name, :desc => self.description)
          result = Jobs.create_job(Jobs.request_category, self.title, message, model)
          if (!result[:error].nil?)
            client.emit_failure result[:error]
          else
            client.emit_success t('jobs.job_created')
          end
        end
      end
    end
  end
end
