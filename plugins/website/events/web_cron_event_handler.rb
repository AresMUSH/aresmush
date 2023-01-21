module AresMUSH
  module Website
    class WebCronEventHandler
      def on_event(event)
        config = Global.read_config("website", "wiki_export_cron")
        if Cron.is_cron_match?(config, event.time)
          export_wiki
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