module AresMUSH
  module Channels
    class ChatRequestHandler
      def handle(request)
        enactor = request.enactor
        
        if (!enactor)
          return { error: t('webportal.login_required') }
        end
        
        error = Website.check_login(request)
        return error if error
                
        channels = []
        
        Channel.all.to_a.sort_by { |c| c.name }.each do |c|
          channels <<  {
          key: c.name.downcase,
          title: c.name,
          enabled: Channels.is_on_channel?(enactor, c),
          allowed: Channels.can_use_channel(enactor, c),
          muted: Channels.is_muted?(enactor, c),
          last_activity: c.last_activity,
          is_page: false,
          who: Channels.channel_who(c).map { |w| {
           name: w.name,
           ooc_name: w.ooc_name,
           icon: Website.icon_for_char(w),
           muted: Channels.is_muted?(w, c)  
          }},
          messages: Channels.is_on_channel?(enactor, c) ? c.messages.map { |m| {
            message: Website.format_markdown_for_html(m['message']),
            timestamp: OOCTime.local_long_timestr(enactor, m['timestamp']) }} : nil,
          }
        end
        
        enactor.page_messages
           .to_a
           .group_by { |p| p.thread_name }
           .sort_by { |name, group_pages | Page.thread_title(name) }
           .each do |name, group_pages |
             chars = Page.chars_for_thread(name)
             sorted_pages = group_pages.sort_by { |p| p.created_at }
             channels << {
               key: name,
               title: chars.sort_by { |c| c.name }.map { |c| c.name }.join(", "),
               enabled: true,
               allowed: true,
               muted: false,
               is_page: true,
               last_activity: sorted_pages[-1].created_at,
               who: chars.map { |c| {
                name: c.name,
                ooc_name: c.ooc_name,
                icon: Website.icon_for_char(c),
                muted: false
               }},
               messages: sorted_pages.map { |p| {
                  from: p.character ? p.character.name : t('global.deleted_character'),
                  message: Website.format_markdown_for_html(p.message),
                  timestamp: OOCTime.local_long_timestr(enactor, p.created_at)
                  }}
            }
          end
                 
        channels
      end
    end
  end
end


