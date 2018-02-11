module AresMUSH
  module Website
    class WebsiteCmd
      include CommandHandler
            
      def handle
        
        client.emit_ooc t('webportal.website_address', 
           :portal => Game.web_portal_url)
      end
    end
  end
end
