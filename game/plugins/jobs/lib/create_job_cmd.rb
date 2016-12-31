module AresMUSH
  module Jobs
    class CreateJobCmd
      include CommandHandler

      attr_accessor :title, :description, :category
      
      def crack!
        if (cmd.args !~ /\//)
          cmd.crack_args!(ArgParser.arg1_equals_arg2)
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
      
      def required_args
        {
          args: [ self.title, self.description, self.category ],
          help: 'jobs'
        }
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        result = Jobs.create_job(self.category, self.title, self.description, enactor)
        if (!result[:error].nil?)
          client.emit_failure result[:error]
        end
      end
    end
  end
end
