module AresMUSH  

  module Migrations
    class MigrationBeta54Update
      def require_restart
        true
      end
      
      def migrate
        
        Global.logger.debug "Removing duplicate optional plugins."
        config = DatabaseMigrator.read_config_file("plugins.yml")
        config['plugins']['optional_plugins'] = config['plugins']['optional_plugins'].uniq
        config['plugins']['disabled_plugins'] = config['plugins']['disabled_plugins'].uniq
        DatabaseMigrator.write_config_file("plugins.yml", config)
       
        Global.logger.debug "Creating login cleanup cron."
        config = DatabaseMigrator.read_config_file("login.yml")
        config['login']['notice_cleanup_cron'] = { 'day' => [18], 'hour' => [02], 'minute' => [19] }
        config['login']['notice_timeout_days'] = 60
        DatabaseMigrator.write_config_file("login.yml", config)
        
        Global.logger.debug "Update fullname shortcut."
        config = DatabaseMigrator.read_config_file("demographics.yml")
        config['demographics']['shortcuts']['fullname'] = 'demographic/set full name='
        DatabaseMigrator.write_config_file("demographics.yml", config)  
      
      
      end 
    end
  end
end