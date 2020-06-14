module AresMUSH  

  module Migrations
    class MigrationBeta79Update
      def require_restart
        false
      end
      
      def migrate
               
        Global.logger.debug "Website update cron."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['sitemap_update_cron']  = { 'hour' => [ 2 ], 'minute' => [ 17 ]}
        config = DatabaseMigrator.write_config_file("website.yml", config)
        
        Global.logger.debug "Fix target defense skill."
        config = DatabaseMigrator.read_config_file("fs3combat_misc.yml")
        if (config['fs3combat']['combatant_types'].has_key?('Target'))
          config['fs3combat']['combatant_types']['Target'].delete 'defense_skill'
        end
        config = DatabaseMigrator.write_config_file("fs3combat_misc.yml", config)
        
      end
    end    
  end
end