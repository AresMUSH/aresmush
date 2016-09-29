module AresMUSH
  module Mail
    class MailInboxCmd
      include CommandHandler
      include CommandRequiresLogin
           
      def handle        
        template = InboxTemplate.new(enactor, Mail.filtered_mail(client), false, enactor.mail_filter)
        client.emit template.render
      end
    end
  end
end
