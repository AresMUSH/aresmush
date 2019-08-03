module AresMUSH  

  module Migrations
    class MigrationBeta59Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Default upload sizes."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['max_upload_size_kb'] = 300
        config['website']['max_folder_size_kb'] = 2000
        config = DatabaseMigrator.write_config_file("website.yml", config)
      end 
    end
  end
end