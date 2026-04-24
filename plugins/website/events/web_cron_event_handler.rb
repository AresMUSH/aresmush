module AresMUSH
  module Website
    class WebCronEventHandler
      def on_event(event)
        config = Global.read_config("website", "wiki_export_cron")
        if Cron.is_cron_match?(config, event.time)
          export_wiki
        end
        
        config = Global.read_config("website", "char_backup_cleanup_cron")
        if Cron.is_cron_match?(config, event.time)
          cleanup_char_backups
        end
      end
      
      def export_wiki
	      # Note: The spawn is inside the export method.
        if (Global.read_config("website", "auto_wiki_export"))      
          Website.export_wiki
        end
      end
      
      def cleanup_char_backups
        WikiCharBackup.all.each do |backup|
          if (backup.hours_old > WikiCharBackup.retention_hours)
            Global.logger.debug "Deleting old backup #{backup.file}"
            backup.delete
          end
        end
      end
      
    end
  end
end