module AresMUSH
  module Jobs
    class ViewJobCmd
      include SingleJobCmd
      
      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          template = JobTemplate.new(client, job)            
          client.emit template.render
          Jobs.mark_read(job, enactor)
        end
      end
    end
  end
end
