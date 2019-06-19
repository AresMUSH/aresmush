module AresMUSH
  module Jobs
    class CloseJobCmd
      include SingleJobCmd
      
      attr_accessor :message
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.number = trim_arg(args.arg1)
        self.message = args.arg2
      end
      
      def handle
        Jobs.with_a_job(enactor, client, self.number) do |job|
          if (!job.is_open?)
            client.emit_failure t('jobs.job_already_closed')
            return
          end
          Jobs.close_job(enactor, job, self.message)
        end
      end
    end
  end
end
