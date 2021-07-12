module AresMUSH
  module Page
    class HidePageThreadRequestHandler
      def handle(request)
        enactor = request.enactor
        thread_id = request.args[:thread_id]
        is_hidden = "#{request.args[:hidden]}".to_bool
        
        error = Website.check_login(request)
        return error if error

        thread = PageThread[thread_id]
        if (!thread)
          return { error: t('page.invalid_thread') }
        end
        
        if (!thread.can_view?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        threads = enactor.hidden_page_threads || []
        if (is_hidden)
          threads << "#{thread.id}"
        else
          threads.delete "#{thread.id}"
        end
        enactor.update(hidden_page_threads: threads)
        
        {
        }
      end
    end
  end
end


