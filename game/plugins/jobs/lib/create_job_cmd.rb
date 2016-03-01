module AresMUSH
  module Jobs
    class CreateJobCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs

      attr_accessor :title, :description, :category
      
      def initialize
        self.required_args = ['title', 'description', 'category']
        self.help_topic = 'jobs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch_is?("create")
      end
      
      def crack!
        if (cmd.args !~ /\//)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.title = trim_input(cmd.args.arg1)
          self.description = cmd.args.arg2
          self.category = "REQ"
        else          
          if (cmd.args =~ /^[^=\/]+=[^\/=]+\/.+/)
            cmd.crack_args!(/(?<category>[^\=]+)=(?<title>[^\/]+)\/(?<description>.+)/)
          else
            cmd.crack_args!(/(?<category>[^\/]+)\/(?<title>[^\=]+)\=(?<description>.+)/)
          end
          self.category = cmd.args.category
          self.title = cmd.args.title
          self.description = cmd.args.description
        end        
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(client.char)
        return nil
      end
      
      def handle
        result = Jobs.create_job(self.category, self.title, self.description, client.char)
        if (!result[:error].nil?)
          client.emit_failure result[:error]
        end
      end
    end
  end
end
