module AresMUSH
  module Website
    class CreateWikiPageRequestHandler
      def handle(request)
        enactor = request.enactor
        text = request.args['text']
        tags = (request.args['tags'] || "").split(" ")
        title = request.args['title']
        name = request.args['name']
    
        error = Website.check_login(request)
        return error if error
        
        Global.logger.info "#{enactor.name} created wiki page #{title} - #{name}."
            
        if (name.blank?)
          name = title
        end
    
        name = WikiPage.sanitize_page_name(name)
        page = WikiPage.find_by_name_or_id(name)
        if (page)
          return { error: t('webportal.page_already_exists')}
        end
        
        if (name.blank?)
          return { error: t('webportal.missing_required_fields', :fields => "name") }
        end
        
        if (name =~ /:/ && name.after(":").blank?)
          return { error: t('webportal.page_name_blank') }
        end
      
        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
      
        page = WikiPage.create(title: title, name: name)
        version = WikiPageVersion.create(wiki_page: page, text: text, character: enactor)
        Website.add_to_recent_changes('wiki', t('webportal.wiki_created', :name => page.title), { version_id: version.id, page_name: name }, enactor.name)
        Website.update_tags(page, tags)
        
        Achievements.award_achievement(enactor, "wiki_create")
        
        {
          id: page.id,
          name: page.name
        }
      end
    end
  end
end