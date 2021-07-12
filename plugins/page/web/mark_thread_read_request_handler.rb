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
        
        
        if (enactor.unified_play_screen)
          thread.characters.each do |p|
            if (AresCentral.is_alt?(p, enactor))
              Page.mark_thread_read(thread, p)
            end
          end
        end
         
        {
        }
      end
    end
  end
end


