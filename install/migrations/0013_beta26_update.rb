module AresMUSH  
  module Migrations
    class MigrationBeta26Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding room exit brackets."
        config = DatabaseMigrator.read_config_file("describe.yml")
        config['describe']['exit_start_bracket'] = '['
        config['describe']['exit_end_bracket'] = ']'
        DatabaseMigrator.write_config_file("describe.yml", config)    
        
      end
    end
  end
end