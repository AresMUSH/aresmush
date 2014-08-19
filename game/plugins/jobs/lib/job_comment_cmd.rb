module AresMUSH
  module Jobs
    class JobCommentCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :number, :message, :admin_only
      
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
      
      def check_number
        return nil if self.number.nil?
        return t('jobs.invalid_request_number') if !self.number.is_integer?
        return nil
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(client.char)
        return nil
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|     
          JobReply.create(:author => client.char, 
            :job => job,
            :admin_only => self.admin_only,
            :message => self.message)
          if (self.admin_only)
            notification = t('jobs.discussed_job', :name => client. name, :number => job.number, :title => job.title)
            Jobs.notify(job, notification, false)
          else
            notification = t('jobs.responded_to_job', :name => client. name, :number => job.number, :title => job.title)
            Jobs.notify(job, notification)
          end
        end
      end
    end
  end
end
