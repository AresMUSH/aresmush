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
      
        error = WebHelpers.check_login(request)
        return error if error
        
        name = WikiPage.sanitize_page_name(name)
        page = WikiPage.find_by_name_or_id(name_or_id)
        if (!page)
          return { error: t('webportal.not_found') }
        end
        
        if ((WebHelpers.is_restricted_wiki_page?(page) && !WebHelpers.can_manage_wiki?(enactor)) ||
          !enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
          
        if (name.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
      
        lock_info = page.get_lock_info(enactor)
        if (lock_info)
          return { error: t('webportal.page_locked', :name => lock_info.locked_by, :time => time) }
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