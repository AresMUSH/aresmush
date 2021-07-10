module AresMUSH
  module Channels
    class JoinChannelRequestHandler
      def handle(request)
        enactor = request.enactor
        channel_name = request.args[:channel]
        char = Character.named(request.args[:char])
        channel = Channel.find_one_by_name(channel_name)
        
        error = Website.check_login(request)
        return error if error

        request.log_request
        
        if (!channel || !char)
          return { error: t('webportal.not_found') }
        end
        
        if (!AresCentral.is_alt?(char, enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        error = Channels.join_channel(channel, char, nil)
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


