module AresMUSH
  module Page
    class SendPageRequestHandler
      def handle(request)
        enactor = request.enactor
        message = request.args[:message]
        thread_id = request.args[:thread_id]
        names = request.args[:names]
        char_name = request.args[:char]
        
        error = Website.check_login(request)
        return error if error

        if (char_name)
          char = Character.named(char_name)
          if (!char)
            return { error: t('webportal.not_found') }
          end
          if (!AresCentral.is_alt?(char, enactor))
            return { error: t('dispatcher.not_allowed') }
          end
        else
          char = enactor
        end
        
        if (thread_id)
          thread = PageThread[thread_id]
          if (!thread)
            return { error: t('page.invalid_thread') }
          end
          if (!thread.can_view?(enactor))
            return { error: t('dispatcher.not_allowed') }
          end
          
          recipients = thread.characters.to_a
        else
          recipients = []
          
          if (!names) 
            return { error: t('webportal.not_found')}
          end
        
          names.each do |name|
            char = Character.find_one_by_name(name)
            if (!char)
              return { error: t('page.invalid_recipient', :name => name) }
            end
            recipients << char
          end
        end
        
        thread = Page.send_page(char, recipients, message, Login.find_client(enactor))
        # Respond to existing thread - no return
        if (thread_id)
          return {}
        else
          return { thread: Channels.build_page_web_data(thread, enactor) }
        end
      end
    end
  end
end


