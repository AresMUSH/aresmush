module AresMUSH
  module Migrations
    class MigrationBeta13Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Fixing scene config typo."
        
        custom_config = DatabaseMigrator.read_config_file("scenes.yml")
        if (!Global.read_config("scenes", "unshared_scene_deletion_days"))
          custom_config["scenes"]["unshared_scene_deletion_days"] = Global.read_config("scenes", "unsared_scene_deletion_days") || 20
        end
        DatabaseMigrator.write_config_file("scenes.yml", custom_config)
                     
      end
    end
  end
end