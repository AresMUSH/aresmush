module AresMUSH
  module Jobs
    class JobMailCmd
      include SingleJobCmd

      attr_accessor :names, :message
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.number = trim_arg(args.arg1)
        self.names = titlecase_list_arg(args.arg2)
        self.message = args.arg3
      end
      
      def required_args
        [ self.number, self.names, self.message ]
      end
      
      def handle
        Jobs.with_a_job(enactor, client, self.number) do |job|  
          display_names = self.names.join(" ")
          mail_sent = Mail.send_mail(self.names, t('jobs.mail_job_title', :title => job.title), self.message, client, enactor)

          if (mail_sent)
            # Create an admin-only comment for the mail   
            Jobs.comment(job, enactor, t('jobs.mail_comment', :names => display_names, :message => self.message), true)
            client.emit_success t('jobs.mail_sent', :names => display_names)
          end
        end
      end
    end
  end
end
