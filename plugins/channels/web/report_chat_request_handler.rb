module AresMUSH
  module Channels
    class ReportChatRequestHandler
      def handle(request)
        enactor = request.enactor
        key = request.args[:key]
        start_message = request.args[:start_message]
        reason = request.args[:reason]
        
        error = Website.check_login(request)
        return error if error
        
        channel = Channel.find_one_by_name(key)
        if (!channel)
          return { error: t('webportal.not_found') }
        end
        
        found = false
        messages = []
        channel.sorted_channel_messages.each do |m|
          if (found)
            messages << m
          elsif (m.id == start_message)
            found = true
            messages << m
          end
        end

        if (!found)
          messages = channel.messages
        end
        Channels.report_channel_abuse(enactor, channel, messages, reason) 
        
        
        {
        }
      end
    end
  end
end


