module AresMUSH
  module Page
    class PageIndexRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        pages = []
        
        enactor.page_messages
           .to_a
           .reverse
           .group_by { |p| p.thread_name }
           .each do |name, group_pages |
             group = {}
             group[:thread_name] = name
             group[:pages] = group_pages.sort_by { |p| p.created_at }.map { |p| {
               from: p.character ? p.character.name : t('global.deleted_character'),
               message: Website.format_markdown_for_html(p.message),
               is_read: p.is_read,
               timestamp: OOCTime.local_long_timestr(enactor, p.created_at)
             }}
             chars = Page.chars_for_thread(name).sort_by { |c| c.name }
             chars.delete(enactor)
             
             group[:can_reply] = chars.all? { |c| !!c }
             group[:chars] = chars.map { |c| c ? c.name : t('global.character_deleted') }
             group[:title] = group[:chars].join(", ")
             group[:is_unread] = group_pages.select { |p| p.is_unread? }
             
             pages << group
         end
        
         pages
      end
    end
  end
end