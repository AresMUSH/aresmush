module AresMUSH
  module Mail
    class MailProofCmd
      include Plugin
      include PluginRequiresLogin
           
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("proof")
      end
      
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(client)
        return nil
      end
            
      def handle
        client.emit BorderedDisplay.text t('mail.proof', 
        :to => client.char.mail_compose_to.join(" "), 
        :subject => client.char.mail_compose_subject,
        :body => client.char.mail_compose_body)
      end
    end
  end
end
