module AresMUSH  
  module Migrations
    class MigrationBeta28Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding scene timeout."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['idle_scene_timeout_days'] = 3
        DatabaseMigrator.write_config_file("scenes.yml", config)    
        
        Global.logger.deub "Adding posebreak shortcut."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['shortcuts']['posebreak'] = 'autospace'
        DatabaseMigrator.write_config_file("scenes.yml", config)    
        
        Global.logger.deub "Adding server SSL options."
        config = DatabaseMigrator.read_config_file("server.yml")
        config['server']['private_key_file_path'] = ''
        config['server']['certificate_file_path'] = ''
        config['server']['use_ssl'] = false
        DatabaseMigrator.write_config_file("server.yml", config)    
        
      end
    end
  end
end