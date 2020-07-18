module AresMUSH  

  module Migrations
    class MigrationBeta82Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Fixing scene emit alias."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['shortcuts'].delete 'scene/emit'
        config['scenes']['shortcuts']['scene/addpose']  = 'scene/emit'
        config['scenes']['shortcuts']['scene/pose']  = 'scene/emit'
        config = DatabaseMigrator.write_config_file("scenes.yml", config)
      end
    end    
  end
end