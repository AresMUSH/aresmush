module AresMUSH  

  module Migrations
    class MigrationBeta54Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Removing duplicate optional plugins."
        config = DatabaseMigrator.read_config_file("plugins.yml")
        config['plugins']['optional_plugins'] = config['plugins']['optional_plugins'].uniq
        config['plugins']['disabled_plugins'] = config['plugins']['disabled_plugins'].uniq
        DatabaseMigrator.write_config_file("plugins.yml", config)
        
      end 
    end
  end
end