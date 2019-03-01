module AresMUSH  
  module Migrations
    class MigrationBeta44Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding update shortcut."
        config = DatabaseMigrator.read_config_file("manage.yml")
        config['manage']['shortcuts']['update'] = 'upgrade'
        DatabaseMigrator.write_config_file("manage.yml", config)  
      end
    end
  end
end
