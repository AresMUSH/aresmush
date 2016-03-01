module AresMUSH
  module Mail
    class MailFwdCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :num
      attr_accessor :names
      attr_accessor :comment
      
      def initialize
        self.required_args = ['names']
        self.help_topic = 'mail'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("fwd")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_optional_arg3)
        self.num = trim_input(cmd.args.arg1)
        self.names = cmd.args.arg2.nil? ? [] : cmd.args.arg2.split(" ")
        self.comment = cmd.args.arg3
      end
      
      def handle
        Mail.with_a_delivery(client, self.num) do |msg|
          Global.logger.debug("#{self.class.name} #{client} forwding message #{self.num} (#{msg.subject}) to #{self.names}.")

          subject = t('mail.forwarded_subject', :subject => msg.subject)
          template = ForwardedTemplate.new(client, delivery, self.comment)
          body = template.build
          
          if (Mail.send_mail(self.names, subject, body, client))
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
