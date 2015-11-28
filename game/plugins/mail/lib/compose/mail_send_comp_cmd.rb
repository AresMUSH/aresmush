module AresMUSH
  module Mail
    class MailSendComposition
      include CommandHandler
      include CommandRequiresLogin
           
      def want_command?(client, cmd)
        (cmd.root_is?("mail") && cmd.switch_is?("send")) || cmd.root == "--"
      end
      
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(client)
        return t('mail.body_empty') if client.char.mail_compose_body.nil?
        return nil
      end
            
      def handle
        if (Mail.send_mail(client.char.mail_compose_to, 
          client.char.mail_compose_subject, 
          client.char.mail_compose_body, 
          client))
          client.emit_ooc t('mail.message_sent')
          Mail.toss_composition(client)
        end
      end
    end
  end
end
