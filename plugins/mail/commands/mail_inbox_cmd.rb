module AresMUSH
  module Mail
    class MailInboxCmd
      include CommandHandler
           
      def handle       
        filter = enactor.mail_filter
        show_from = filter != Mail.sent_tag && !filter.start_with?("review")
        template = InboxTemplate.new(enactor, Mail.filtered_mail(enactor, enactor.mail_filter), show_from, filter)
        client.emit template.render
      end
    end
  end
end
