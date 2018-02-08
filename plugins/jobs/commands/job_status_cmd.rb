module AresMUSH
  module Jobs
    class JobStatusCmd
      include SingleJobCmd
  
      attr_accessor :value
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.number = trim_arg(args.arg1)
        self.value = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.number, self.value ]
      end

      def check_status
        return nil if !self.value
        return t('jobs.invalid_status', :statuses => Jobs.status_vals.join(", ")) if (!Jobs.status_vals.include?(self.value.upcase))
        return nil
      end
  
      def handle
        Jobs.with_a_job(enactor, client, self.number) do |job|
          Jobs.change_job_status(enactor, job, self.value.upcase)
        end
      end
    end
  end
end