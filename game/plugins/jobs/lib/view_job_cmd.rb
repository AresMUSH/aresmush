module AresMUSH
  module Jobs
    class ViewJobCmd
      include SingleJobCmd
      
      def help
        "`jobs` - Lists jobs\n" +
        "`job <#>` - Views a job."
      end
      
      def parse_args
        self.number = trim_arg(cmd.args)
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          template = JobTemplate.new(enactor, job)            
          client.emit template.render
          Jobs.mark_read(job, enactor)
        end
      end
    end
  end
end
