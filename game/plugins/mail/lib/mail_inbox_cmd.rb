module AresMUSH
  module Mail
    class MailInboxCmd
      include CommandHandler
      include CommandRequiresLogin
           
      def handle        
        prefs = Mail.get_or_create_mail_prefs(enactor)
        show_from = prefs.mail_filter != Mail.sent_tag && !prefs.mail_filter.start_with?("review")
        template = InboxTemplate.new(enactor, Mail.filtered_mail(enactor), show_from, prefs.mail_filter)
        client.emit template.render
      end
    end
  end
end
