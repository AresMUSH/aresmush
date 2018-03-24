module AresMUSH
  module Mail
    class MailFwdCmd
      include CommandHandler
           
      attr_accessor :num
      attr_accessor :names
      attr_accessor :comment
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
        self.num = trim_arg(args.arg1)
        self.names = list_arg(args.arg2)
        self.comment = args.arg3
      end

      def required_args
        [ self.names ]
      end
      
      def handle
        Mail.with_a_delivery(client, enactor, self.num) do |msg|
          Global.logger.debug("#{self.class.name} #{client} forwding message #{self.num} (#{msg.subject}) to #{self.names}.")

          subject = t('mail.forwarded_subject', :subject => msg.subject)
          template = ForwardedTemplate.new(enactor, msg, self.comment)
          body = template.render
          
          if (Mail.send_mail(self.names, subject, body, client, enactor))
            client.emit_ooc t('mail.message_forwarded')
          end
        end
      end
      
      def log_command
        # Don't log full command for message privacy
      end
    end
  end
end
