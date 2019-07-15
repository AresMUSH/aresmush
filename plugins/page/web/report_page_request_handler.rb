module AresMUSH
  module Page
    class ReportPageRequestHandler
      def handle(request)
        enactor = request.enactor
        key = request.args[:key]
        message_ids = request.args[:messages] || []
        reason = request.args[:reason]
                
        error = Website.check_login(request)
        return error if error

        thread = PageThread[key]
        if (!thread)
          return { error: t('page.invalid_thread') }
        end
        
        messages = thread.page_messages.select { |m| message_ids.include?(m.id) }
        Page.report_page_abuse(enactor, thread, messages, reason)
         
        {
        }
      end
    end
  end
end


