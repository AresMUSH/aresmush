module AresMUSH
  module Website
    class GetWikiPageRequestHandler
      def handle(request)
        name_or_id = request.args[:id]
        edit_mode = request.args[:edit_mode]
        
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        if (!name_or_id || name_or_id.blank?)
          name_or_id = 'home'
        end
        
        name_or_id = WikiPage.sanitize_page_name(name_or_id)
        page = WikiPage.find_by_name_or_id(name_or_id)
        if (!page)
          return { 
            not_found: true, 
            title: name_or_id.titleize,
            templates: Website.wiki_templates
           }
        end
        
        can_manage_wiki = Website.can_manage_wiki?(enactor)
        lock_info = page.get_lock_info(enactor)
        restricted_page = Website.is_restricted_wiki_page?(page)
        if (edit_mode)
          if (restricted_page && !can_manage_wiki)
            return { error: t('dispatcher.not_allowed') }
          end
          if (!lock_info)
            page.update(locked_by: enactor)
            page.update(locked_time: Time.now)
          end
          text = page.text
        else
          text = Website.format_markdown_for_html page.text
        end
        
        can_edit = enactor && enactor.is_approved? && !lock_info && ( can_manage_wiki || !restricted_page )
            
        breadcrumbs = []
        breadcrumbs << { title: "Home", url: "home" }
        if (page.name =~ /:/)
          page_category = page.name.before(':')
          if (page_category)
            cat_page = WikiPage.named(page_category)
            if (!cat_page)
              cat_page = WikiPage.named("#{page_category}s")
            end
            if (cat_page)
              breadcrumbs << { title: cat_page.heading, url: cat_page.name }
            else
              breadcrumbs << { title: page_category.titleize, url: nil }
            end
          end
        end
        if (page.name != 'home')
          breadcrumbs << { title: page.heading, url: nil }
        end
        
        {
          id: page.id,
          heading: page.heading,
          title: page.title,
          name: page.name,
          text: text,
          tags: page.content_tags,
          lock_info: lock_info,
          can_delete: can_manage_wiki && !restricted_page,
          can_edit: can_edit,
          can_do_minor_edits: can_manage_wiki,
          current_version_id: page.current_version.id,
          breadcrumbs: breadcrumbs,
          can_change_name: can_edit
        }
      end
    end
  end
end