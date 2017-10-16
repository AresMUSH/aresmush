module AresMUSH
  module Website
    class WikiRebuildCmd
      include CommandHandler
            
      def handle
        
        WikiPage.all.each do |w|
          w.update(html: nil)
        end
          
        client.emit_success t('website.rebuilding_done')        
      end
    end
  end
end


