module AresMUSH
  module Mail
    class MailTagsRequestHandler
      def handle(request)
        enactor = request.enactor
        message = MailMessage[request.args[:id]]
        tags = request.args[:tags] || []
        
        error = Website.check_login(request)
        return error if error

        if (tags.empty?)
          return { error: t('mail.tags_cant_be_empty') }
        end
        
        if (!message)
          return { error: t('db.object_not_found') }
        end
        
        if (message.character != enactor)
          return { error: t('dispatcher.not_allowed') }
        end
        
        message.update(tags: tags)
        
       {
        }
      end
    end
  end
end