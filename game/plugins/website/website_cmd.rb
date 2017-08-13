module AresMUSH
  module Website
    class WebsiteCmd
      include CommandHandler
            
      def handle
        
        client.emit_ooc t('web.website_address', 
           :portal => Game.web_portal_url, 
           :wiki => Game.wiki_url)
      end
    end
  end
end
