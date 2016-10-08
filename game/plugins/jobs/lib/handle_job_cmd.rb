module AresMUSH
  module Jobs
    class HandleJobCmd
      include SingleJobCmd
      
      attr_accessor :assignee
      
      def crack!
        if (cmd.args =~ /\=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.number = trim_input(cmd.args.arg1)
          self.assignee = trim_input(cmd.args.arg2)
        else
          self.number = trim_input(cmd.args)
          self.assignee = enactor_name
        end
      end
      
      def required_args
        {
          args: [ self.number ],
          help: 'jobs'
        }
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          ClassTargetFinder.with_a_character(self.assignee, client, enactor) do |target|
            if (!Jobs.can_access_jobs?(target))
              client.emit_failure t('jobs.cannot_handle_jobs')
              return
            end
            job.assigned_to = target
            job.status = "OPEN"
            job.save
            notification = t('jobs.job_assigned', :number => job.number, :title => job.title, :assigner => enactor_name, :assignee => target.name)
            Jobs.notify(job, notification, enactor)
          end
        end
      end
    end
  end
end
