module AresMUSH
  module Jobs
    class RequestCommentCmd
      include CommandHandler

      attr_accessor :number, :message
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.number = trim_arg(args.arg1)
        self.message = args.arg2
      end
      
      def required_args
        [ self.number, self.message ]
      end
      
      def check_number
        return nil if !self.number
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def handle
        Jobs.with_a_request(client, enactor, self.number) do |request|     
          Jobs.comment(request, enactor, self.message, false)
        end
      end
    end
  end
end
