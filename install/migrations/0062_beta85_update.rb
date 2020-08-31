module AresMUSH  

  module Migrations
    class MigrationBeta85Update
      def require_restart
        false
      end
      
      def migrate
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config["scenes"]["shortcuts"]['scene/mine'] = 'scene/unshared'
        DatabaseMigrator.write_config_file("scenes.yml", config)
      end
    end    
  end
end