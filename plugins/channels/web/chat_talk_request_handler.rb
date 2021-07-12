module AresMUSH
  module Channels
    class ChatTalkRequestHandler
      def handle(request)
        enactor = request.enactor
        channel = Channel.find_one_by_name(request.args[:channel])
        message = request.args[:message]
        sender = Character.named(request.args[:sender])
        
        error = Website.check_login(request)
        return error if error
                
        if (!channel || !sender)
          return { error: t('webportal.not_found') }
        end

        if (!AresCentral.is_alt?(sender, enactor))
          return { error: t('dispatcher.not_allowed') }
        end
                        
        if (!Channels.is_on_channel?(sender, channel) || !Channels.can_talk_on_channel?(sender, channel))
          return { error:  t('channels.cant_talk_on_channel') }
        end
 
        options = Channels.get_channel_options(sender, channel)
        message = Channels.pose_to_channel channel, sender, message, options.title   
        
        {
          message: Website.format_markdown_for_html(message)
        }
      end
    end
  end
end


