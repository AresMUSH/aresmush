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
        composition = enactor.mail_composition
        
        body_so_far = composition.body
        if (!body_so_far)
          composition.body = self.body
        else
          composition.body = "#{body_so_far}%R%R#{self.body}"
        end
        composition.save
        
        client.emit_ooc t('mail.mail_added')
      end
      
      def log_command
        # Don't log full command for message privacy
        Global.logger.debug("#{self.class.name} #{client} added to mail message.")
      end
    end
  end
end
