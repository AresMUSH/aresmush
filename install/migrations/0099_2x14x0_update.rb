module AresMUSH  

  module Migrations
    class Migration2x14x0Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Remove auto wiki export."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website'].delete 'wiki_export_cron'
        config['website'].delete 'auto_wiki_export'
        DatabaseMigrator.write_config_file("website.yml", config)
      end
    end
  end    
end