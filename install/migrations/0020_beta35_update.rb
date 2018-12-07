module AresMUSH  
  module Migrations
    class MigrationBeta35Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding web submit flag."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['allow_web_submit'] = true
        DatabaseMigrator.write_config_file("chargen.yml", config)    
  
        Global.logger.debug "Adding achievement shortcut."
        config = DatabaseMigrator.read_config_file("achievements.yml")
        config['achievements']['shortcuts'] = { 'achievements' => 'achievement' }
        DatabaseMigrator.write_config_file("achievements.yml", config)    
    
        Global.logger.debug "Adding room owners shortcut."
        config = DatabaseMigrator.read_config_file("rooms.yml")
        config['rooms']['shortcuts']['owners'] = 'owner'
        DatabaseMigrator.write_config_file("rooms.yml", config)    
    
        
      end
    end
  end
end