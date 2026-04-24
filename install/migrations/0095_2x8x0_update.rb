module AresMUSH  

  module Migrations
    class Migration2x8x0Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Adding max connections"
        config = DatabaseMigrator.read_config_file("sites.yml")
        config["sites"]["max_connections"] = 20
        DatabaseMigrator.write_config_file("sites.yml", config)
        
        Global.logger.debug "Adding location legend"
        config = DatabaseMigrator.read_config_file("rooms.yml")
        config["rooms"]["icon_legend"] = {}
        DatabaseMigrator.write_config_file("rooms.yml", config)        
      end
    end
  end    
end