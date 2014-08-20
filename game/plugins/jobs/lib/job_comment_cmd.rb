module AresMUSH
  module Jobs
    class JobCommentCmd
      include SingleJobCmd

      attr_accessor :message, :admin_only
      
      def initialize
        self.required_args = ['number', 'message']
        self.help_topic = 'jobs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && (cmd.switch_is?("discuss") || cmd.switch_is?("respond"))
      end
      
      def crack!
        # Has to be done first!  Crack will reset command aliases.
        self.admin_only = cmd.switch_is?("discuss")

        cmd.crack!(CommonCracks.arg1_equals_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.message = cmd.args.arg2
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|     
          Jobs.comment(job, client.char, self.message, self.admin_only)
        end
      end
    end
  end
end
