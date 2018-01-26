module AresMUSH
  module Jobs
    class JobCommentCmd
      include SingleJobCmd

      attr_accessor :message, :admin_only
      
      def parse_args
        # Has to be done first!  Crack will reset command aliases.
        self.admin_only = cmd.switch_is?("discuss")

        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.number = trim_arg(args.arg1)
        self.message = args.arg2
      end
      
      def required_args
        [ self.number, self.message ]
      end
      
      def handle
        Jobs.with_a_job(enactor, client, self.number) do |job|     
          Jobs.comment(job, enactor, self.message, self.admin_only)
        end
      end
    end
  end
end
