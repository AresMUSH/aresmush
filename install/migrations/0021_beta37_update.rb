module AresMUSH  
  
  module Migrations
    class MigrationBeta37Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding achievement channel config."
        config = DatabaseMigrator.read_config_file("achievements.yml")
        config['achievements']['announce_channel'] = ""
        DatabaseMigrator.write_config_file("achievements.yml", config)    
  
       
      end
    end
  end
end