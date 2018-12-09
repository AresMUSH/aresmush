module AresMUSH
  module Mail
    class MailUndeleteRequestHandler
      def handle(request)
        enactor = request.enactor
        message = MailMessage[request.args[:id]]
        
        error = Website.check_login(request)
        return error if error

        if (!message)
          return { error: t('db.object_not_found') }
        end
        
        if (message.character != enactor)
          return { error: t('dispatcher.not_allowed') }
        end
        
        Mail.remove_from_trash(message)
        
       {
       }
      end
    end
  end
end