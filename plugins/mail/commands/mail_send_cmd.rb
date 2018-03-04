module AresMUSH
  module Mail
    class MailSendCmd
      include CommandHandler
           
      attr_accessor :names
      attr_accessor :subject
      attr_accessor :body
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.names = list_arg(args.arg1)
        self.subject = trim_arg(args.arg2)
        self.body = args.arg3
      end

      def required_args
        [ self.names, self.subject, self.body ]
      end
      
      def handle
        if (Mail.send_mail(self.names, self.subject, self.body, client, enactor))
          client.emit_ooc t('mail.message_sent')
        end
      end
      
      def log_command
        # Don't log full command for message privacy
        Global.logger.debug("#{self.class.name} #{client} sending mail.")
      end
    end
  end
end
