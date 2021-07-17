module AresMUSH
  module Channels
    class DownloadChatRequestHandler
      def handle(request)
        enactor = request.enactor
        key = request.args[:key]
        is_page = (request.args[:is_page] || "").to_s.to_bool
                
        error = Website.check_login(request)
        return error if error

        request.log_request

        if (is_page)
          thread = PageThread[key]
          if (!thread)
            return { error: t('page.invalid_thread') }
          end
        
          if (!thread.can_view?(enactor))
            return { error: t('dispatcher.not_allowed') }
          end
        
          log = thread.characters.map { |p| p.name }.join(" ")
          log << "\n"
          log << OOCTime.local_long_timestr(enactor, DateTime.now)
          log << "\n"
          thread.sorted_messages.each do |m|
            log << "\n\n[#{OOCTime.local_long_timestr(enactor, m.created_at)}] #{m.message}"
          end
        
        else
          
          channel = Channel.find_one_by_name(key)
        
          if (!channel)
            return { error: t('webportal.not_found') }
          end
          
          if !Channels.has_alt_on_channel?(enactor, channel)
            return { error: t('dispatcher.not_allowed') }
          end
        
          log = channel.name
          log << "\n"
          log << OOCTime.local_long_timestr(enactor, DateTime.now)
          log << "\n"
          channel.sorted_channel_messages.each do |m|
            log << "\n\n[#{OOCTime.local_long_timestr(enactor, m.created_at)}] #{m.message}"
          end
        end
        
         
        {
          log: log
        }
      end
    end
  end
end


