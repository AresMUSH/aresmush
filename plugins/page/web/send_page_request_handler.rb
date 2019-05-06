module AresMUSH
  module Page
    class SendPageRequestHandler
      def handle(request)
        enactor = request.enactor
        message = request.args[:message]
        thread = request.args[:thread]
        names = request.args[:names]
        
        if (!enactor)
          return { error: t('webportal.login_required') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (thread)
          recipients = Page.chars_for_thread(thread)
          if (recipients.any? { |r| !r })
            return { error: t('page.cannot_continue_conversation') }
          end
        else
          recipients = []
          names.each do |name|
            char = Character.find_one_by_name(name)
            if (!char)
              return { error: t('page.invalid_recipient', :name => name) }
            end
            recipients << char
          end
        end
        
        thread = Page.send_page(enactor, recipients, message, nil)

        {
          thread: thread
        }
      end
    end
  end
end


