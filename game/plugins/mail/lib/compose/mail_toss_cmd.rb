module AresMUSH
  module Mail
    class MailTossCmd
      include CommandHandler
           
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(enactor)
        return nil
      end
            
      def handle
        Mail.toss_composition(enactor)
        client.emit_success t('mail.mail_composition_tossed')
      end
    end
  end
end
