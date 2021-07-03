module AresMUSH
  module Page
    class ReportPageRequestHandler
      def handle(request)
        enactor = request.enactor
        key = request.args[:key]
        start_message = request.args[:start_message]
        reason = request.args[:reason]
                
        error = Website.check_login(request)
        return error if error

        request.log_request

        thread = PageThread[key]
        if (!thread)
          return { error: t('page.invalid_thread') }
        end
        
        if (!thread.can_view?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        found = false
        messages = []
        thread.sorted_messages.each do |m|
          if (found)
            messages << m
          elsif (m.id == start_message)
            found = true
            messages << m
          end
        end

        if (!found)
          messages = thread.sorted_messages
        end
        
        Page.report_page_abuse(enactor, thread, messages, reason)
         
        {
        }
      end
    end
  end
end


