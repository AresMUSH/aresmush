module AresMUSH
  module Jobs
    class ViewJobCmd
      include SingleJobCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch.nil?
      end
      
      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          client.emit Jobs.job_renderer.render(client, job)
          Jobs.mark_read(job, client.char)
        end
      end
    end
  end
end
