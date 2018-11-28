module AresMUSH
  module Mail
    class MailDeleteRequestHandler
      def handle(request)
        enactor = request.enactor
        message = MailMessage[request.args[:id]]
        
        error = Website.check_login(request)
        return error if error

        if (!message)
          return { error: t('webportal.missing_required_fields') }
        end
        
        
        if (message.character != enactor)
          return { error: t('dispatcher.not_allowed') }
        end
        
        message.delete
        
       {
       }
      end
    end
  end
end