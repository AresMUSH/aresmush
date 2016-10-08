module AresMUSH
  module Jobs
    class JobCommentCmd
      include SingleJobCmd

      attr_accessor :message, :admin_only
      
      def crack!
        # Has to be done first!  Crack will reset command aliases.
        self.admin_only = cmd.switch_is?("discuss")

        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.message = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.number, self.message ],
          help: 'jobs'
        }
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|     
          Jobs.comment(job, enactor, self.message, self.admin_only)
        end
      end
    end
  end
end
