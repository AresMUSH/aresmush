module AresMUSH  

  module Migrations
    class MigrationBeta67Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add CG system config."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['ability_system'] = 'fs3'
        config['chargen']['ability_system_app_review_header'] = 'Abilities (help abilities)'
        DatabaseMigrator.write_config_file("chargen.yml", config)
      end 
    end
  end
end