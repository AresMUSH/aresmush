module AresMUSH
  module Jobs
    class JobStatusCmd
      include SingleJobCmd
  
      attr_accessor :value
  
      def initialize
        self.required_args = ['number', 'value']
        self.help_topic = 'jobs'
        super
      end
  
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.value = cmd.args.arg2
      end

      def check_status
        return nil if self.value.nil?
        return t('jobs.invalid_status', :statuses => Jobs.status_vals) if (!Jobs.status_vals.include?(self.value.upcase))
        return nil
      end
  
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          Jobs.change_job_status(client, job, self.value.upcase)
        end
      end
    end
  end
end