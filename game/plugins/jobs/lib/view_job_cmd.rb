module AresMUSH
  module Jobs
    class ViewJobCmd
      include SingleJobCmd
      
      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          client.emit Jobs.get_job_display(client, job)
          Jobs.mark_read(job, client.char)
        end
      end
    end
  end
end
