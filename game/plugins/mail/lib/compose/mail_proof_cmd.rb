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
        composition = enactor.mail_composition
        
        client.emit BorderedDisplay.text t('mail.proof', 
        :to => composition.to_list.join(" "), 
        :subject => composition.subject,
        :body => composition.body)
      end
    end
  end
end
