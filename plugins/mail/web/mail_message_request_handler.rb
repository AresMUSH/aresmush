module AresMUSH
  module Mail
    class MailMessageRequestHandler
      def handle(request)
        enactor = request.enactor
        message = MailMessage[request.args[:id]]
        
        error = Website.check_login(request)
        return error if error

        if (!message)
          return { error: t('webportal.not_found') }
        end
        
        if (message.character != enactor)
          return { error: t('dispatcher.not_allowed') }
        end
        
        Mail.mark_read(message, enactor)
        thread = message.thread ? message.thread : message
        Mail.build_mail_web_data(thread, enactor)
      end
    end
  end
end