module AresMUSH
  module Website
    class CancelEditWikiPageRequestHandler
      def handle(request)
        name_or_id = request.args['id']
        enactor = request.enactor

        error = Website.check_login(request)
        return error if error
        
        name = WikiPage.sanitize_page_name(name)
        page = WikiPage.find_by_name_or_id(name_or_id)
        if (!page)
          return { error: t('webportal.not_found') }
        end
        
        lock_info = page.get_lock_info(enactor)
        if (lock_info)
          return
        end

        page.update(locked_by: nil)
        
        {
        }
      end
    end
  end
end