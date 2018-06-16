module AresMUSH
  module Website
    class WebCronEventHandler
      def on_event(event)
        config = Global.read_config("website", "sitemap_update_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        path = File.join(AresMUSH.game_path, 'sitemap.txt')
        File.open(path, 'w') do |file|
          topics = WebHelpers.build_sitemap
          topics.each do |t|
            file.puts t
          end
        end
        
      end
    end
  end
end