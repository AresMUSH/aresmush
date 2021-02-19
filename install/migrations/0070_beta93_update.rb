module AresMUSH  

  module Migrations
    class MigrationBeta93Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding debug setting."
        config = DatabaseMigrator.read_config_file("channels.yml")
        config['channels']['debug_discord'] = false
        DatabaseMigrator.write_config_file("channels.yml", config)
      end
    end    
  end
end