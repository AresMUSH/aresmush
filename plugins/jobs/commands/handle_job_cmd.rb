module AresMUSH
  module Jobs
    class HandleJobCmd
      include SingleJobCmd
      
      attr_accessor :assignee
      
      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.number = trim_arg(args.arg1)
          self.assignee = trim_arg(args.arg2)
        else
          self.number = trim_arg(cmd.args)
          self.assignee = enactor_name
        end
      end
      
      def required_args
        [ self.number ]
      end
      
      def handle
        Jobs.with_a_job(enactor, client, self.number) do |job|
          ClassTargetFinder.with_a_character(self.assignee, client, enactor) do |target|
            if (!Jobs.can_access_jobs?(target))
              client.emit_failure t('jobs.cannot_handle_jobs')
              return
            end
            Jobs.assign(job, target, enactor)
          end
        end
      end
    end
  end
end
