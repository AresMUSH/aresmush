module AresMUSH  

  module Migrations
    class Migration1x3x0Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add scheduled jobs."
        config = DatabaseMigrator.read_config_file("jobs.yml")
        config["jobs"]["scheduled_jobs"] = []
        config["jobs"]["custom_fields"] = []
        DatabaseMigrator.write_config_file("jobs.yml", config)    
      end
    end
  end    
end