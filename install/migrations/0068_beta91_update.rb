module AresMUSH  

  module Migrations
    class MigrationBeta91Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding allowable extensions."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['uploadable_extensions'] = [ '.jpg', '.png', '.gif' ]
        DatabaseMigrator.write_config_file("website.yml", config)
        
      end
    end    
  end
end