module AresMUSH
  module Mail
    class MailInboxCmd
      include CommandHandler
      include CommandRequiresLogin
           
      def handle        
        template = InboxTemplate.new(client, Mail.filtered_mail(client), false, client.char.mail_filter)
        template.render
      end
    end
  end
end
