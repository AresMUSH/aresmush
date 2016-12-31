module AresMUSH
  module Jobs
    class JobStatusCmd
      include SingleJobCmd
  
      attr_accessor :value
  
      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.value = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.number, self.value ],
          help: 'jobs'
        }
      end

      def check_status
        return nil if !self.value
        return t('jobs.invalid_status', :statuses => Jobs.status_vals.join(", ")) if (!Jobs.status_vals.include?(self.value.upcase))
        return nil
      end
  
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          Jobs.change_job_status(enactor, job, self.value.upcase)
        end
      end
    end
  end
end