module AresMUSH  

  module Migrations
    class MigrationBeta79Update
      def require_restart
        false
      end
      
      def migrate
               
        Global.logger.debug "Website update cron."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['sitemap_update_cron']  = { 'hour' => [ '2' ], 'minute' => [ '17' ]}
        config = DatabaseMigrator.write_config_file("website.yml", config)
        
      end
    end    
  end
end