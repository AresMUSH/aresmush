module AresMUSH
  module Jobs
    class CreateJobCmd
      include CommandHandler

      attr_accessor :title, :description, :category
      
      def parse_args
        if (cmd.args !~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.title = trim_arg(args.arg1)
          self.description = args.arg2
          self.category = Jobs.request_category
        else          
          if (cmd.args =~ /^[^=\/]+=[^\/=]+\/.+/)
            args = cmd.parse_args(/(?<category>[^\=]+)=(?<title>[^\/]+)\/(?<description>.+)/)
          else
            args = cmd.parse_args(/(?<category>[^\/]+)\/(?<title>[^\=]+)\=(?<description>.+)/)
          end
          self.category = args.category ? trim_arg(args.category.upcase) : nil
          self.title = trim_arg(args.title)
          self.description = args.description
        end        
      end
      
      def required_args
        {
          args: [ self.title, self.description, self.category ],
          help: 'jobs manage'
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
