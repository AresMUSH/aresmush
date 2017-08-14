module AresMUSH
  module Jobs
    class DeleteJobCmd
      include SingleJobCmd
      
      def help
        "`job/delete <#>` - Deletes a particular job."
      end
      
      def parse_args
        self.number = trim_arg(cmd.args)
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          notification = t('jobs.job_deleted', :title => job.title, :name => enactor_name)
          Jobs.notify(job, notification, enactor)
          job.delete
        end
      end
    end
  end
end
