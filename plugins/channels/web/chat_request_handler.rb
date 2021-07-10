module AresMUSH
  module Channels
    class ChatRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
                
        channels = []
        alts = []
        
        Channel.all.to_a.each do |c|
          channels <<  Channels.build_channel_web_data(c, enactor, true)
        end
        
        AresCentral.play_screen_alts(enactor).each do |char|
          char.page_threads
             .to_a
             .each do |t|
               if (!channels.any? { |c| c[:key] == t.id } )
                 channels << Channels.build_page_web_data(t, enactor, true)
               end
          end
          
          alts <<  { id: char.id, name: char.name, icon: Website.icon_for_char(char) }
        end

        Login.mark_notices_read(enactor, :pm)

        {
          channels: channels,
          pose_chars: alts
        }                 
        
      end
    end
  end
end


