module AresMUSH
  module Mail
    class MailFwdCmd
      include CommandHandler
           
      attr_accessor :num
      attr_accessor :names
      attr_accessor :comment
      
      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_arg2_slash_optional_arg3)
        self.num = trim_input(cmd.args.arg1)
        self.names = !cmd.args.arg2 ? [] : cmd.args.arg2.split(" ")
        self.comment = cmd.args.arg3
      end

      def required_args
        {
          args: [ self.names ],
          help: 'mail'
        }
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
