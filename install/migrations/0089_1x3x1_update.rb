module AresMUSH  

  module Migrations
    class Migration1x3x1Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add max bg size."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config["chargen"]["max_bg_length"] = 0
        DatabaseMigrator.write_config_file("chargen.yml", config)    
      end
    end
  end    
end