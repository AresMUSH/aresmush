module AresMUSH
  module Migrations
    class MigrationBeta17Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Scene pose divider."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['include_pose_separator'] = false
        DatabaseMigrator.write_config_file("scenes.yml", config)
        
      end
    end
  end
end