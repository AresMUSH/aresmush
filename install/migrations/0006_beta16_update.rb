module AresMUSH
  module Migrations
    class MigrationBeta16Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Sitemap update."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['sitemap_update_cron'] = { 'hour' => [02], 'minute' => [17] }
        DatabaseMigrator.write_config_file("website.yml", config)
        
      end
    end
  end
end