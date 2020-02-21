module AresMUSH
  module Mail
    class MailScanCmd
      include CommandHandler
      
      def handle
        count = enactor.unread_mail.count
        if (count == 0)
          client.emit_ooc t('mail.no_unread_messages')
        else
          client.emit_success t('mail.unread_messages', :count => count)
        end
      end
    end
  end
end
