module AresMUSH  

  module Migrations
    class MigrationBeta92Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding randomized guests."
        config = DatabaseMigrator.read_config_file("login.yml")
        config['login']['random_guest_selection'] = false
        DatabaseMigrator.write_config_file("login.yml", config)
      end
    end    
  end
end