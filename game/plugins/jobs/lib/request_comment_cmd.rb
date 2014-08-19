module AresMUSH
  module Jobs
    class RequestCommentCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :number, :message
      
      def initialize
        self.required_args = ['number', 'message']
        self.help_topic = 'requests'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("request") && cmd.switch_is?("comment")
      end
      
      def crack!
        cmd.crack!(CommonCracks.arg1_equals_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.message = cmd.args.arg2
      end
      
      def check_number
        return nil if self.number.nil?
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def handle
        Jobs.with_a_request(client, self.number) do |request|     
          JobReply.create(:author => client.char, 
            :job => request,
            :admin_only => false,
            :message => self.message)
          notification = t('jobs.commented_on_request', :name => client.name, :number => request.number, :title => request.title)
          Jobs.notify(job, notification, false)
        end
      end
    end
  end
end
