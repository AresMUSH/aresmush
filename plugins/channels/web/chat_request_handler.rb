module AresMUSH
  module Channels
    class ChatRequestHandler
      def handle(request)
        enactor = request.enactor
        
        if (!enactor)
          return { error: t('webportal.login_required') }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
                
        channels = {}
        
        Channel.all.map { |c| 
          channels[c.name.downcase] = {
          name: c.name,
          enabled: Channels.is_on_channel?(enactor, c),
          allowed: Channels.can_use_channel(enactor, c),
          muted: Channels.is_muted?(enactor, c),
          who: Channels.channel_who(c).map { |w| {
           name: w.name,
           ooc_name: w.ooc_name,
           icon: WebHelpers.icon_for_char(w),
           muted: Channels.is_muted?(w, c)  
          }},
          messages: Channels.is_on_channel?(enactor, c) ? c.messages.map { |m| {
            message: WebHelpers.format_markdown_for_html(m['message']),
            timestamp: OOCTime.local_long_timestr(enactor, m['timestamp']) }} : nil
          }}
        
        {
          channels: channels
        }
      end
    end
  end
end


