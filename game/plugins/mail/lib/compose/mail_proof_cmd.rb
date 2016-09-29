module AresMUSH
  module Mail
    class MailProofCmd
      include CommandHandler
      include CommandRequiresLogin
           
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(enactor)
        return nil
      end
            
      def handle
        client.emit BorderedDisplay.text t('mail.proof', 
        :to => enactor.mail_compose_to.join(" "), 
        :subject => enactor.mail_compose_subject,
        :body => enactor.mail_compose_body)
      end
    end
  end
end
