module AresMUSH
  module Mail
    class MailSendComposition
      include CommandHandler
      include CommandRequiresLogin
           
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(enactor)
        return t('mail.body_empty') if !enactor.mail_compose_body
        return nil
      end
            
      def handle
        if (Mail.send_mail(enactor.mail_compose_to, 
          enactor.mail_compose_subject, 
          enactor.mail_compose_body, 
          client, enactor))
          client.emit_ooc t('mail.message_sent')
          Mail.toss_composition(enactor)
        end
      end
    end
  end
end
