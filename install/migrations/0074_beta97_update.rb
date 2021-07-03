module AresMUSH  

  module Migrations
    class MigrationBeta97Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding wiki export."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['auto_wiki_export'] = true
        DatabaseMigrator.write_config_file("website.yml", config)          
      end
    end
  end    
end