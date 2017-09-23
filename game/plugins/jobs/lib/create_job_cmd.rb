module AresMUSH
  module Jobs
    class CreateJobCmd
      include CommandHandler

      attr_accessor :title, :description, :category
      
      def parse_args
        if (cmd.args !~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          
          self.title = trim_arg(args.arg1)

          # If first arg is a category, then second arg is the title
          if (Jobs.categories.include?(title.upcase))
            self.description = "--"
            self.category = self.title
            self.title = trim_arg(args.arg2)
          else            
            self.description = args.arg2
            self.category = Jobs.request_category
          end
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
        [ self.title, self.description, self.category ]
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
