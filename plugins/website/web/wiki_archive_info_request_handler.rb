module AresMUSH
  module Website
    class WikiArchiveInfoHandler
      def handle(request)
        enactor = request.enactor
        error = Website.check_login(request, true)
        return error if error

        backup_path = File.join(AresMUSH.game_path, "wiki_export.zip")
        
        {
          auto_export: Global.read_config("website", "auto_wiki_export"),
          export_available: File.exist?(backup_path),
          last_exported: OOCTime.local_long_timestr(enactor, File.ctime(backup_path))
        }
      end
    end
  end
end