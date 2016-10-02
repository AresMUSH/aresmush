module AresMUSH
  module Mail
    class MailAppendCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :body
      
      def crack!
        self.body = cmd.raw.after("-").chomp
      end
      
      def required_args
        {
          args: [ self.body ],
          help: 'mail composition'
        }
      end
      
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(enactor)
        return nil
      end
      
      def handle
        body_so_far = enactor.mail_compose_body
        if (!body_so_far)
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
