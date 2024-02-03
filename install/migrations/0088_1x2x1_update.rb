module AresMUSH  

  module Migrations
    class Migration1x2x1Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add scheduled jobs."
        config = DatabaseMigrator.read_config_file("jobs.yml")
        config["scheduled_jobs"] = []
        config["custom_fields"] = []
        DatabaseMigrator.write_config_file("jobs.yml", config)    
      end
    end
  end    
end