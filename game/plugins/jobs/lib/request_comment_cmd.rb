module AresMUSH
  module Jobs
    class RequestCommentCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs

      attr_accessor :number, :message
      
      def initialize(client, cmd, enactor)
        self.required_args = ['number', 'message']
        self.help_topic = 'requests'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.message = cmd.args.arg2
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
