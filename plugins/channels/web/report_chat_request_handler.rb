module AresMUSH
  module Channels
    class ReportChatRequestHandler
      def handle(request)
        enactor = request.enactor
        key = request.args[:key]
        message_ids = request.args[:messages] || []
        reason = request.args[:reason]
        
        error = Website.check_login(request)
        return error if error
        
        channel = Channel.find_one_by_name(key)
        if (!channel)
          return { error: t('webportal.not_found') }
        end
        
        messages = channel.messages.select { |m| message_ids.include?(m['id']) }
        Channels.report_channel_abuse(enactor, channel, messages, reason) 
        
        
        {
        }
      end
    end
  end
end


