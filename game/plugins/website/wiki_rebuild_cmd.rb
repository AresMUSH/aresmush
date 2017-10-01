module AresMUSH
  module Website
    class WikiRebuildCmd
      include CommandHandler
            
      def handle
        
        if (!AresMUSH.web_server)
          client.emit_failure t('website.rebuilding_requires_wiki_load')
          return
        end
        
        client.emit_ooc t('website.rebuilding_wiki')
        
        Global.dispatcher.spawn("Updating wiki cache", client) do
        
          md = WikiMarkdownFormatter.new(false, AresMUSH.web_server)
          WikiPage.all.each do |w|
            w.update(html: md.to_html(w.current_version.text))
          end
          
          client.emit_success t('website.rebuilding_done')

        end
        
        
      end
    end
  end
end


