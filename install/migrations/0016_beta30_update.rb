module AresMUSH  
  module Migrations
    class MigrationBeta30Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding birthday shortcut."
        config = DatabaseMigrator.read_config_file("demographics.yml")
        config['demographics']['shortcuts']['birthday'] = 'birthdate'
        DatabaseMigrator.write_config_file("demographics.yml", config)    
      end
    end
  end
end