module AresMUSH
  module Mail
    class MailSendCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :names
      attr_accessor :subject
      attr_accessor :body
      
      def initialize(client, cmd, enactor)
        self.required_args = ['names', 'subject', 'body']
        self.help_topic = 'mail'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_arg3)
        self.names = cmd.args.arg1.nil? ? [] : cmd.args.arg1.split(" ")
        self.subject = cmd.args.arg2
        self.body = cmd.args.arg3
      end
      
      def handle
        if (Mail.send_mail(self.names, self.subject, self.body, client))
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
