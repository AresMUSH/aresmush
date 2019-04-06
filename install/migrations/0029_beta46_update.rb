module AresMUSH  
  module Migrations
    class MigrationBeta46Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding request filter shortcuts."
        config = DatabaseMigrator.read_config_file("jobs.yml")
        config['jobs']['shortcuts']['request/all'] = 'request/filter all'
        config['jobs']['shortcuts']['request/active'] = 'request/filter active'
        DatabaseMigrator.write_config_file("jobs.yml", config)  
        
        
      end
    end
  end
end
