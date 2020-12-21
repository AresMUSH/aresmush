module AresMUSH
  module Website
    class DeleteWikiPageRequestHandler
      def handle(request)
        name_or_id = request.args[:id]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        page = WikiPage.find_by_name_or_id(name_or_id)
        if (!page)
          return { error: t('webportal.not_found') }
        end
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end

        Website.add_to_recent_changes('wiki', t('webportal.wiki_deleted', :name => page.title), { version_id: 0, page_name: page.name }, enactor.name)
          
        page.delete
        
        {
        }
      end
    end
  end
end