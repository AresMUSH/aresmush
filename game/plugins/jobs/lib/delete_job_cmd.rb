module AresMUSH
  module Jobs
    class DeleteJobCmd
      include SingleJobCmd
      
      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          notification = t('jobs.job_deleted', :title => job.title, :name => client.name)
          Jobs.notify(job, notification, client.char)
          job.destroy
        end
      end
    end
  end
end
