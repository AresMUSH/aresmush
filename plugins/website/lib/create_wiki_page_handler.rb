module AresMUSH
  module Website
    class CreateWikiPageRequestHandler
      def handle(request)
        enactor = request.enactor
        text = request.args[:text]
        tags = (request.args[:tags] || []).map { |t| t.downcase }
        title = request.args[:title]
        name = request.args[:title]
      
        if (enactor)
          error = WebHelpers.validate_auth_token(request)
          return error if error
        end
        
        name = WikiPage.sanitize_page_name(name)
        page = WikiPage.find_by_name_or_id(name)
        if (page)
          return { error: 'That page already exists.'}
        end
        
        if (name.blank?)
          return { error: "Page name cannot be empty." }
        end
      
        if (!enactor.is_approved?)
          return { error: "You are not allowed to do that." }
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