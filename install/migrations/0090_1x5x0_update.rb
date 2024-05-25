module AresMUSH  

  module Migrations
    class Migration1x5x0Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Fix default discord debug option."
        config = DatabaseMigrator.read_config_file("channels.yml")
        debug_discord = config["channels"]["debug_discord"]
        if (debug_discord)
          config["channels"]["discord_debug"] = false
          config["channels"].delete("debug_discord")
          DatabaseMigrator.write_config_file("channels.yml", config)    
        end
      end
    end
  end    
end