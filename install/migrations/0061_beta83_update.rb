module AresMUSH  

  module Migrations
    class MigrationBeta83Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding luck job option."
        config = DatabaseMigrator.read_config_file("fs3skills_misc.yml")
        config['fs3skills']['job_on_luck_spend'] = true
        config = DatabaseMigrator.write_config_file("fs3skills_misc.yml", config)
      end
    end    
  end
end