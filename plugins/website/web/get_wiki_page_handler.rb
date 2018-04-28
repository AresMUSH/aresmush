module AresMUSH
  module Website
    class GetWikiPageRequestHandler
      def handle(request)
        name_or_id = request.args[:id]
        edit_mode = request.args[:edit_mode]
        
        enactor = request.enactor
        
        error = WebHelpers.check_login(request, true)
        return error if error
        
        if (!name_or_id || name_or_id.blank?)
          name_or_id = 'home'
        end
        
        name_or_id = WikiPage.sanitize_page_name(name_or_id)
        page = WikiPage.find_by_name_or_id(name_or_id)
        if (!page)
          return { not_found: true, title: name_or_id.titleize }
        end
        
        lock_info = page.get_lock_info(enactor)
        restricted_page = WebHelpers.is_restricted_wiki_page?(page)
        if (edit_mode)
          if (restricted_page && !WebHelpers.can_manage_wiki?(enactor))
            return { error: t('dispatcher.not_allowed') }
          end
          if (!lock_info)
            page.update(locked_by: enactor)
            page.update(locked_time: Time.now)
          end
          text = page.text
        else
          text = WebHelpers.format_markdown_for_html page.text
        end
        
        can_edit = enactor && enactor.is_approved? && !lock_info && ( WebHelpers.can_manage_wiki?(enactor) || !restricted_page )
                    
        {
          id: page.id,
          heading: page.heading,
          title: page.title,
          name: page.name,
          text: text,
          tags: page.tags,
          lock_info: lock_info,
          can_delete: enactor && enactor.is_admin? && !restricted_page,
          can_edit: can_edit,
          current_version_id: page.current_version.id,
          can_change_name: can_edit
        }
      end
    end
  end
end