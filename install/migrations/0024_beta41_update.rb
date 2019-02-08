module AresMUSH  
  
  module Migrations
    class MigrationBeta41Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding channel recall size."
        config = DatabaseMigrator.read_config_file("channels.yml")
        config['channels']['recall_buffer_size'] = 500
        DatabaseMigrator.write_config_file("channels.yml", config)    
      end
    end
  end
end
