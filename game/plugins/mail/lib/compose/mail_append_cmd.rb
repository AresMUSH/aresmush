module AresMUSH
  module Mail
    class MailAppendCmd
      include CommandHandler
           
      attr_accessor :body
      
      def parse_args
        self.body = cmd.raw.after("-").chomp
      end
      
      def required_args
        [ self.body ]
      end
      
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(enactor)
        return nil
      end
      
      def handle
        composition = enactor.mail_composition
        
        body_so_far = composition.body
        if (!body_so_far)
          composition.update(body: self.body)
        else
          composition.update(body: "#{body_so_far}%R%R#{self.body}")
        end
        
        client.emit_ooc t('mail.mail_added')
      end
      
      def log_command
        # Don't log full command for message privacy
        Global.logger.debug("#{self.class.name} #{client} added to mail message.")
      end
    end
  end
end
