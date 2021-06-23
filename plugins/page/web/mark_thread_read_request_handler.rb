module AresMUSH
  module Page
    class MarkThreadReadRequestHandler
      def handle(request)
        enactor = request.enactor
        thread_id = request.args[:thread_id]
        
        error = Website.check_login(request)
        return error if error

        thread = PageThread[thread_id]
        if (!thread)
          return { error: t('page.invalid_thread') }
        end
        
        if (!thread.can_view?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        
        Page.mark_thread_read(thread, enactor)
         
        {
        }
      end
    end
  end
end


