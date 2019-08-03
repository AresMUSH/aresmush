module AresMUSH
  module Channels
    class ChatRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
                
        channels = []
        
        Channel.all.to_a.sort_by { |c| c.name }.each do |c|
          channels <<  {
          key: c.name.downcase,
          title: c.name,
          enabled: Channels.is_on_channel?(enactor, c),
          can_join: Channels.can_join_channel?(enactor, c),
          can_talk: Channels.can_talk_on_channel?(enactor, c),
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
            id: m['id'],
            timestamp: OOCTime.local_long_timestr(enactor, m['timestamp']) }} : nil,
          }
        end
        
        enactor.page_threads
           .to_a
           .sort_by { |t| t.title_without_viewer(enactor) }
           .each do |t|
             channels << {
               key: t.id,
               title: t.title_without_viewer(enactor),
               enabled: true,
               can_join: true,
               can_talk: true,
               muted: false,
               is_page: true,
               is_unread: Page.is_thread_unread?(t, enactor),
               last_activity: t.last_activity,
               who: t.characters.map { |c| {
                name: c.name,
                ooc_name: c.ooc_name,
                icon: Website.icon_for_char(c),
                muted: false
               }},
               messages: t.sorted_messages.map { |p| {
                  message: Website.format_markdown_for_html(p.message),
                  id: p.id,
                  timestamp: OOCTime.local_long_timestr(enactor, p.created_at)
                  }}
            }
          end
                 
        channels
      end
    end
  end
end


