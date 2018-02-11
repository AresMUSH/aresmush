module AresMUSH
  module Website
    class CreateWikiPageRequestHandler
      def handle(request)
        enactor = request.enactor
        text = request.args[:text]
        tags = (request.args[:tags] || []).map { |t| t.downcase }
        title = request.args[:title]
        name = request.args[:title]
    
        error = WebHelpers.check_login(request)
        return error if error
        
        name = WikiPage.sanitize_page_name(name)
        page = WikiPage.find_by_name_or_id(name)
        if (page)
          return { error: t('webportal.page_already_exists')}
        end
        
        if (name.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
      
        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
      
        page = WikiPage.create(tags: tags, title: title, name: name)
        WikiPageVersion.create(wiki_page: page, text: text, character: enactor)
        
        {
          id: page.id,
          name: page.name
        }
      end
    end
  end
end