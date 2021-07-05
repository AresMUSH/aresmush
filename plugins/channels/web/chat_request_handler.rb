module AresMUSH
  module Channels
    class ChatRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
                
        channels = []
        
        Channel.all.to_a.each do |c|
          channels <<  Channels.build_channel_web_data(c, enactor, true)
        end
        
        AresCentral.alts(enactor).each do |char|
          char.page_threads
             .to_a
             .each do |t|
               if (!channels.any? { |c| c[:key] == t.id } )
                 channels << Channels.build_page_web_data(t, enactor, true)
               end
          end
        end

        Login.mark_notices_read(enactor, :pm)
                 
        channels
      end
    end
  end
end


