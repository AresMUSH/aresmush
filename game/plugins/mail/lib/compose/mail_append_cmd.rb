module AresMUSH
  module Mail
    class MailAppendCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :body
      
      def initialize(client, cmd, enactor)
        self.required_args = ['body']
        self.help_topic = 'mail composition'
        super
      end
      
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(client)
        return nil
      end
      
      def crack!
        self.body = cmd.raw.after("-").chomp
      end
      
      def handle
        body_so_far = enactor.mail_compose_body
        if (body_so_far.nil?)
          enactor.mail_compose_body = self.body
        else
          enactor.mail_compose_body = "#{body_so_far}%R%R#{self.body}"
        end
        enactor.save
        
        client.emit_ooc t('mail.mail_added')
      end
      
      def log_command
        # Don't log full command for message privacy
        Global.logger.debug("#{self.class.name} #{client} added to mail message.")
      end
    end
  end
end
