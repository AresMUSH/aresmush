module AresMUSH
  module Channels
    class ChatTalkRequestHandler
      def handle(request)
        enactor = request.enactor
        channel = Channel.find_one_by_name(request.args[:channel])
        message = request.args[:message]
        
        if (!enactor)
          return { error: "You must log in first." }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
                
        if (!channel)
          return { error: "Channel not found!" }
        end
        
        message = Channels.pose_to_channel channel, enactor.name, message    
        
        {
          message: WebHelpers.format_markdown_for_html(message)
        }
      end
    end
  end
end


