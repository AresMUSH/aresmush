module AresMUSH
  module Mail
    class MailDeleteRequestHandler
      def handle(request)
        enactor = request.enactor
        message = MailMessage[request.args[:id]]
        
        error = Website.check_login(request)
        return error if error

        request.log_request

        if (!message)
          return { error: t('db.object_not_found') }
        end
        
        
        if (message.character != enactor)
          return { error: t('dispatcher.not_allowed') }
        end
        
        tags = message.tags
        tags << Mail.trashed_tag
        message.update(tags: tags)
        
       {
       }
      end
    end
  end
end