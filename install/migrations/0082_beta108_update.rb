module AresMUSH  

  module Migrations
    class MigrationBeta108Update
      def require_restart
        false
      end
      
      def migrate

        Global.logger.debug "Add default boot timeout."
        config = DatabaseMigrator.read_config_file("login.yml")
        config['login']['boot_timeout_seconds'] = 300
        DatabaseMigrator.write_config_file("login.yml", config)     
      end
    end
  end    
end