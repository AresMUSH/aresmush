module AresMUSH  
  module Migrations
    class MigrationBeta45Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding mail brackets."
        config = DatabaseMigrator.read_config_file("mail.yml")
        config['mail']['end_marker'] = ']'
        config['mail']['start_marker'] = '['
        DatabaseMigrator.write_config_file("mail.yml", config)  
        
        Global.logger.debug "Adding scene skip shortcut."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['shortcuts']['pose/skip'] = 'pose/drop'
        DatabaseMigrator.write_config_file("scenes.yml", config)  
        
      end
    end
  end
end
