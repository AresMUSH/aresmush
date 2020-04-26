module AresMUSH
  module Channels
    class ChatRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
                
        channels = []
        
        Channel.all.to_a.each do |c|
          channels <<  Channels.build_channel_web_data(c, enactor)
        end
        
        enactor.page_threads
           .to_a
           .each do |t|
             channels << Channels.build_page_web_data(t, enactor)
          end

        Login.mark_notices_read(enactor, :pm)
                 
        channels
      end
    end
  end
end


