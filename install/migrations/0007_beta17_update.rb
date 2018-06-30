module AresMUSH
  module Migrations
    class MigrationBeta17Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Scene pose divider."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['include_pose_separator'] = false
        DatabaseMigrator.write_config_file("scenes.yml", config)
        
        Global.logger.debug "Sitemap update."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['sitemap_update_cron'] = { 'hour' => [02], 'minute' => [17] }
        DatabaseMigrator.write_config_file("website.yml", config)
        
      end
    end
  end
end