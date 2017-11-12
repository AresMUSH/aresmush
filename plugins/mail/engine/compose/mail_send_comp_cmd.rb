module AresMUSH
  module Mail
    class MailSendComposition
      include CommandHandler
           
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(enactor)
        return t('mail.body_empty') if !enactor.mail_composition.body
        return nil
      end
            
      def handle
        composition = enactor.mail_composition
        
        if (Mail.send_mail(composition.to_list, 
          composition.subject, 
          composition.body, 
          client, enactor))
          client.emit_ooc t('mail.message_sent')
          Mail.toss_composition(enactor)
        end
      end
    end
  end
end
