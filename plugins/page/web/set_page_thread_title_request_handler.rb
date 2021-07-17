module AresMUSH
  module Page
    class SetPageThreadTitleRequestHandler
      def handle(request)
        enactor = request.enactor
        thread_id = request.args[:thread_id]
        title = request.args[:title]
        
        error = Website.check_login(request)
        return error if error

        thread = PageThread[thread_id]
        if (!thread)
          return { error: t('page.invalid_thread') }
        end
        
        if (!thread.can_view?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        
        custom_titles = thread.custom_titles || {}
        if (title.blank?)
          custom_titles.delete "#{enactor.id}"
          title = thread.title_without_viewer(enactor)
        else
          custom_titles["#{enactor.id}"] = title
        end
        thread.update(custom_titles: custom_titles)
        
        {
          title: title
        }
      end
    end
  end
end


