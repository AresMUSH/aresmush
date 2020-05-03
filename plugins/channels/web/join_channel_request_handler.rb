module AresMUSH
  module Channels
    class JoinChannelRequestHandler
      def handle(request)
        enactor = request.enactor
        channel_name = request.args[:channel]
        channel = Channel.find_one_by_name(channel_name)
        
        error = Website.check_login(request)
        return error if error
                
        if (!channel)
          return { error: t('webportal.not_found') }
        end
        
        error = Channels.join_channel(channel, enactor, nil)
        if (error)
          return { error: error }
        end
                 
        {
          channel: Channels.build_channel_web_data(channel, enactor)
        }
      end
    end
  end
end


