module AresMUSH
  module Jobs
    class RequestCommentCmd
      include CommandHandler

      attr_accessor :number, :message
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.message = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.number, self.message ],
          help: 'requests'
        }
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
