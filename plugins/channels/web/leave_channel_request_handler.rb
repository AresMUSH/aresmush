module AresMUSH
  module Channels
    class LeaveChannelRequestHandler
      def handle(request)
        enactor = request.enactor
        channel_name = request.args[:channel]
        channel = Channel.find_one_by_name(channel_name)
        char = Character.named(request.args[:char])
        
        error = Website.check_login(request)
        return error if error
                
        request.log_request
        
        if (!channel || !char)
          return { error: t('webportal.not_found') }
        end
        
        if (!AresCentral.is_alt?(char, enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        Channels.leave_channel(char, channel)
        
        {
          enabled: AresCentral.alts(enactor).any? { |a| Channels.is_on_channel?(a, channel) }
        }
      end
    end
  end
end


