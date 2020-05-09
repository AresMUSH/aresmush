module AresMUSH
  module Channels
    class MuteChannelRequestHandler
      def handle(request)
        enactor = request.enactor
        channel_name = request.args[:channel]
        channel = Channel.find_one_by_name(channel_name)
        mute = (request.args[:mute] || "").to_bool
        
        error = Website.check_login(request)
        return error if error
                
        if (!channel)
          return { error: t('webportal.not_found') }
        end
        
        Channels.set_muted(enactor, channel, mute)
                 
        {
          channel: Channels.build_channel_web_data(channel, enactor)
        }
      end
    end
  end
end


