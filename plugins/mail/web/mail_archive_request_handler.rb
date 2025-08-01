module AresMUSH
  module Mail
    class MailArchiveRequestHandler
      def handle(request)
        enactor = request.enactor
        message = MailMessage[request.args['id']]
        
        error = Website.check_login(request)
        return error if error

        request.log_request

        if (!message)
          return { error: t('webportal.missing_required_fields', :fields => "message") }
        end
                
        if (!AresCentral.is_alt?(message.character, enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        Mail.archive_delivery(message)
        
       {
       }
      end
    end
  end
end