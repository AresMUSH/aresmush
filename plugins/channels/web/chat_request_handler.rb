module AresMUSH
  module Channels
    class ChatRequestHandler
      def handle(request)
        enactor = request.enactor
        
        if (!enactor)
          return { error: "You must log in first." }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
                
        channels = {}
        
        Channel.all.map { |c| 
          channels[c.name.downcase] = {
          name: c.name,
          enabled: Channels.is_on_channel?(enactor, c),
          allowed: Channels.can_use_channel(enactor, c),
          messages: Channels.is_on_channel?(enactor, c) ? c.messages.map { |m| WebHelpers.format_markdown_for_html(m) } : nil
          }}
        
        {
          channels: channels
        }
      end
    end
  end
end


