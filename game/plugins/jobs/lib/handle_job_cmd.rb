module AresMUSH
  module Jobs
    class HandleJobCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :number, :assignee
      
      def initialize
        self.required_args = ['number']
        self.help_topic = 'jobs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && (cmd.switch_is?("handle") || cmd.switch_is?("assign"))
      end
      
      def crack!
        if (cmd.args =~ /\=/)
          cmd.crack!(CommonCracks.arg1_equals_arg2)
          self.number = trim_input(cmd.args.arg1)
          self.assignee = trim_input(cmd.args.arg2)
        else
          self.number = trim_input(cmd.args)
          self.assignee = client.name
        end
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(client.char)
        return nil
      end
      
      def check_number
        return nil if self.number.nil?
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          ClassTargetFinder.with_a_character(self.assignee, client) do |target|
            if (!Jobs.can_access_jobs?(target))
              client.emit_failure t('jobs.cannot_handle_jobs')
              return
            end
            job.assigned_to = target
            job.status = "OPEN"
            job.save
            notification = t('jobs.job_assigned', :number => job.number, :title => job.title, :assigner => client.name, :assignee => target.name)
            Jobs.notify(job, notification)
          end
        end
      end
    end
  end
end
