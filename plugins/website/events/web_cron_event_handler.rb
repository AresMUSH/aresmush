module AresMUSH
  module Website
    class WebCronEventHandler
      def on_event(event)
        config = Global.read_config("website", "sitemap_update_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        path = File.join(AresMUSH.game_path, 'sitemap.xml')
        File.open(path, 'w') do |file|
          file.puts '<?xml version="1.0" encoding="UTF-8"?>'
          file.puts '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
          
          topics = WebHelpers.build_sitemap
          topics.each do |t|
            file.puts "   <url><loc>#{URI.escape(t)}</loc></url>"
          end
          file.puts '</urlset>'
        end
        
      end
    end
  end
end