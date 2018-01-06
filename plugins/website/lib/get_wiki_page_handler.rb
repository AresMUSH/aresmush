module AresMUSH
  module Website
    class GetWikiPageRequestHandler
      def handle(request)
        name_or_id = request.args[:id]
        edit_mode = request.args[:edit_mode]
        
        enactor = request.enactor
        
        if (enactor)
          error = WebHelpers.validate_auth_token(request)
          return error if error
        end
        
        if (!name_or_id || name_or_id.blank?)
          name_or_id = 'home'
        end
        
        page = WikiPage.find_by_name_or_id(name_or_id)
        if (!page)
          return { error: 'Page not found.'}
        end
        
        lock_info = page.get_lock_info(enactor)
        
        if (edit_mode)
          if (page.is_special_page? && !enactor.is_admin?)
            return { error: "You are not allowed to do that." }
          end
          if (lock_info)
            return { error: "That page is locked by #{lock_info.locked_by}.  Their lock will expire at #{time} or when they're done editing." }
          end
          page.update(locked_by: enactor)
          page.update(locked_time: Time.now)
          text = page.text
        else
          text = WebHelpers.format_markdown_for_html page.text
        end
            
        {
          id: page.id,
          heading: page.heading,
          title: page.title,
          name: page.name,
          text: text,
          tags: page.tags,
          lock_info: lock_info,
          can_delete: enactor && enactor.is_admin? && !page.is_special_page?,
          can_edit: enactor && enactor.is_approved? && ( enactor.is_admin? || !page.is_special_page? ),
          current_version_id: page.current_version.id,
          can_change_name: !page.is_special_page?
        }
      end
    end
  end
end