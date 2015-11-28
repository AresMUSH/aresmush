module AresMUSH
  module Mail
    class MailTossCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
           
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("toss")
      end
      
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(client)
        return nil
      end
            
      def handle
        Mail.toss_composition(client)
        client.emit_success t('mail.mail_composition_tossed')
      end
    end
  end
end
