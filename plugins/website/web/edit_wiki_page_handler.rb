module AresMUSH
  module Website
    class EditWikiPageRequestHandler
      def handle(request)
        name_or_id = request.args[:id]
        enactor = request.enactor
        text = request.args[:text]
        tags = (request.args[:tags] || []).map { |t| t.downcase }.select { |t| !t.blank? }
        title = request.args[:title]
        name = request.args[:name]
        minor_edit = (request.args[:minor_edit] || "").to_bool
      
        error = Website.check_login(request)
        return error if error
        
        name = WikiPage.sanitize_page_name(name)
        page = WikiPage.find_by_name_or_id(name_or_id)
        if (!page)
          return { error: t('webportal.not_found') }
        end
        
        if ((Website.is_restricted_wiki_page?(page) && !Website.can_manage_wiki?(enactor)) ||
          !enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
          
        if (name.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
        
        if (name =~ /:/ && name.after(":").blank?)
          return { error: t('webportal.page_name_blank') }
        end
      
        lock_info = page.get_lock_info(enactor)
        if (lock_info)
          return { error: t('webportal.page_locked', :name => lock_info.locked_by, :time => time) }
        end

        page.update(tags: tags, title: title, name: name, locked_by: nil)
        version = WikiPageVersion.create(wiki_page: page, text: text, character: enactor)
        if (!minor_edit)
          Website.add_to_recent_changes('wiki', t('webportal.wiki_updated', :name => page.title), { version_id: version.id, page_name: page.name }, enactor.name)
        end
        
        Achievements.award_achievement(enactor, "wiki_edit")
        
        {
          id: page.id,
          name: page.name
        }
      end
    end
  end
end