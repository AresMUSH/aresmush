module AresMUSH
  module Channels
    class LeaveChannelRequestHandler
      def handle(request)
        enactor = request.enactor
        channel_name = request.args[:channel]
        channel = Channel.find_one_by_name(channel_name)
        
        error = Website.check_login(request)
        return error if error
                
        request.log_request
        
        if (!channel)
          return { error: t('webportal.not_found') }
        end
        
        Channels.leave_channel(enactor, channel)
                         
        {
        }
      end
    end
  end
end


