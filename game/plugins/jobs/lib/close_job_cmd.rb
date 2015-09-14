module AresMUSH
  module Jobs
    class CloseJobCmd
      include SingleJobCmd
      
      attr_accessor :message
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch_is?("close")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.message = cmd.args.arg2
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          if (job.status == Jobs.closed_status)
            client.emit_failure t('jobs.job_already_closed')
            return
          end
          Jobs.close_job(client, job, self.message)
        end
      end
    end
  end
end
