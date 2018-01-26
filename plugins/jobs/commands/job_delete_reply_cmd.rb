module AresMUSH
  module Jobs
    class JobDeleteReplyCmd
      include SingleJobCmd

      attr_accessor :reply_num
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.number = trim_arg(args.arg1)
        self.reply_num = args.arg2 ? args.arg2.to_i : 0
      end
      
      def required_args
        [ self.number, self.reply_num ]
      end
      
      def handle
        Jobs.with_a_job(enactor, client, self.number) do |job|  
          
          reply = job.job_replies.to_a[self.reply_num - 1]
          if (self.reply_num <= 0 || !reply)
            client.emit_failure t('jobs.invalid_reply_number')
            return
          end
          
          reply.delete
          client.emit_success t('jobs.reply_deleted')
        end
      end
    end
  end
end
