module AresMUSH
  module Jobs
    class RequestMailCmd
      include CommandHandler

      attr_accessor :number, :names, :message
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.number = trim_arg(args.arg1)
        self.names = titlecase_list_arg(args.arg2)
        self.message = args.arg3
      end
      
      def required_args
        [ self.number, self.message, self.names ]
      end
      
      def check_number
        return nil if !self.number
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def handle
        Jobs.with_a_request(client, enactor, self.number) do |request|     
          Mail.send_mail(self.names, t('jobs.mail_job_title', :title => request.title), self.message, client, enactor)
          display_names = self.names.join(" ")
          
          # Create an admin-only comment for the mail   
          Jobs.comment(request, enactor, t('jobs.mail_comment', :names => display_names, :message => self.message), false)
          
          client.emit_success t('jobs.mail_sent', :names => display_names)
        end
      end
    end
  end
end
