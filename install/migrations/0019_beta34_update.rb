module AresMUSH  
  module Migrations
    class MigrationBeta34Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding app review commandst."
        default_config = DatabaseMigrator.read_distr_config_file("chargen.yml")
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['app_review_commands'] = default_config['chargen']['app_review_commands']
        DatabaseMigrator.write_config_file("chargen.yml", config)    
  
      end
    end
  end
end