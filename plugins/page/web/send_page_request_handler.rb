module AresMUSH
  module Page
    class SendPageRequestHandler
      def handle(request)
        enactor = request.enactor
        message = request.args[:message]
        thread_id = request.args[:thread_id]
        names = request.args[:names]
        
        error = Website.check_login(request)
        return error if error

        if (thread_id)
          thread = PageThread[thread_id]
          if (!thread)
            return { error: t('page.invalid_thread') }
          end
          recipients = thread.characters.select { |c| c != enactor }
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
        
        thread = Page.send_page(enactor, recipients, message, Login.find_client(enactor))
        
        {
          thread: Channels.build_page_web_data(thread, enactor)
        }
      end
    end
  end
end


