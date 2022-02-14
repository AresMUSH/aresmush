module AresMUSH
  module Website
    class WebCronEventHandler
      def on_event(event)
        config = Global.read_config("website", "sitemap_update_cron")
        if Cron.is_cron_match?(config, event.time)
          update_sitemap
        end
        
        config = Global.read_config("website", "wiki_export_cron")
        if Cron.is_cron_match?(config, event.time)
          export_wiki
        end
        
      end
      
      def update_sitemap
        Global.logger.debug "Updating sitemap."
        path = File.join(AresMUSH.game_path, 'sitemap.xml')
        File.open(path, 'w') do |file|
          file.puts '<?xml version="1.0" encoding="UTF-8"?>'
          file.puts '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
          
          topics = Website.build_sitemap
          topics.each do |t|
            file.puts " <url>"
            file.puts "   <loc>#{URI.escape(t['url'])}</loc>"
            file.puts "   <lastmod>#{t['lastmod'] || Time.now.strftime('yyyy-mm-dd')}</lastmod>"
            file.puts "   <changefreq>#{t['changefreq'] || 'always' }</changefreq>"
            file.puts " </url>"
          end
          file.puts '</urlset>'
        end
      end
      
      def export_wiki
	      # Note: The spawn is inside the export method.
        if (Global.read_config("website", "auto_wiki_export"))      
          Website.export_wiki
        end
      end
    end
  end
end