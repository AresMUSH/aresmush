module AresMUSH
  module Channels
    class LoadChatMessagesRequestHandler
      def handle(request)
        enactor = request.enactor
        key = request.args[:key]
        is_page = (request.args[:is_page] || "").to_s.to_bool
        
        error = Website.check_login(request)
        return error if error
                
        if (is_page)
          thread = PageThread[key]
          
          if (!thread)
            return { error: t('webportal.not_found') }
          end
        
          if (!thread.can_view?(enactor))
            return { error: t('dispatcher.not_allowed') }
          end
        
          Channels.build_page_web_data(thread, enactor)
          
        else
          
          channel = Channel.find_one_by_name(key)
        
          if (!channel)
            return { error: t('webportal.not_found') }
          end
        
          if !Channels.is_on_channel?(enactor, channel)
            return { error: t('dispatcher.not_allowed') }
          end
        
          Channels.build_channel_web_data(channel, enactor)
        end
      end
    end
  end
end


