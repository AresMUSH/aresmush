module AresMUSH
  module Website
    class EditWikiPageRequestHandler
      def handle(request)
        name_or_id = request.args[:id]
        enactor = request.enactor
        text = request.args[:text]
        tags = (request.args[:tags] || []).map { |t| t.downcase }
        title = request.args[:title]
        name = request.args[:name]
      
        if (enactor)
          error = WebHelpers.check_login(request)
          return error if error
        end
        
        name = WikiPage.sanitize_page_name(name)
        page = WikiPage.find_by_name_or_id(name_or_id)
        if (!page)
          return { error: 'Page not found.'}
        end
        
        if ((page.is_special_page? && !enactor.is_admin?) ||
          !enactor.is_approved?)
          return { error: "You are not allowed to do that." }
        end
          
        if (name.blank?)
          return { error: "Page name cannot be empty." }
        end
      
        lock_info = page.get_lock_info(enactor)
        if (lock_info)
          return { error: "That page is locked by #{lock_info.locked_by}.  Their lock will expire at #{time} or when they're done editing." }
        end

        page.update(tags: tags, title: title, name: name)
        WikiPageVersion.create(wiki_page: page, text: text, character: enactor)
        
        {
          id: page.id,
          name: page.name
        }
      end
    end
  end
end