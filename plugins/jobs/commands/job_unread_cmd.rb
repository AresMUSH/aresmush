module AresMUSH
  module Jobs
    class JobUnreadCmd
      include SingleJobCmd
      
      def parse_args
        self.number = trim_arg(cmd.args)
      end
      
      def handle
        Jobs.with_a_job(enactor, client, self.number) do |job|     
          Jobs.mark_unread(job, enactor)
          client.emit_success t('jobs.job_marked_unread')
        end
      end
    end
  end
end
