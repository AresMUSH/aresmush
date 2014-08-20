module AresMUSH
  module Jobs
    class CloseJobCmd
      include SingleJobCmd
      
      attr_accessor :message
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch_is?("close")
      end
      
      def crack!
        cmd.crack!(CommonCracks.arg1_equals_optional_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.message = cmd.args.arg2
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|

          if (self.message)
            Jobs.comment(job, client.char, self.message, false)
          end
          job.status = "DONE"
          job.save
          
          notification = t('jobs.closed_job', :number => job.number, :title => job.title, :name => client.name)
          Jobs.notify(job, notification, client.char)
        end
      end
    end
  end
end
