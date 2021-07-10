module AresMUSH
  module Page
    class SendPageRequestHandler
      def handle(request)
        enactor = request.enactor
        message = request.args[:message]
        thread_id = request.args[:thread_id]
        names = request.args[:names]
        sender_name = request.args[:sender]
        
        error = Website.check_login(request)
        return error if error

        if (sender_name)
          sender = Character.named(sender_name)
          if (!sender)
            return { error: t('webportal.not_found') }
          end
          if (!AresCentral.is_alt?(sender, enactor))
            return { error: t('dispatcher.not_allowed') }
          end
        else
          sender = enactor
        end
        
        if (thread_id)
          thread = PageThread[thread_id]
          if (!thread)
            return { error: t('page.invalid_thread') }
          end
          if (!thread.can_view?(enactor))
            return { error: t('dispatcher.not_allowed') }
          end
          
          recipients = thread.characters.select { |c| c != sender }
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
        
        thread = Page.send_page(sender, recipients, message, Login.find_client(enactor))
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


