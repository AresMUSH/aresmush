module AresMUSH  
  module Migrations
    class MigrationBeta24Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding date hour offset."
        config = DatabaseMigrator.read_config_file("ictime.yml")
        config['ictime']['hour_offset'] = 0
        DatabaseMigrator.write_config_file("ictime.yml", config)           

        Global.logger.debug "Moving calendar tz to server tz."

        timezone = Global.read_config("events", "calendar_timezone")
        
        config = DatabaseMigrator.read_config_file("events.yml")
        config['events'].delete('calendar_timezone')
        DatabaseMigrator.write_config_file("events.yml", config)           
        
        config = DatabaseMigrator.read_config_file("datetime.yml")
        config['datetime']['server_timezone'] = timezone
        DatabaseMigrator.write_config_file("datetime.yml", config)    
        
        config = DatabaseMigrator.read_config_file("fs3combat_npcs.yml")
        config['fs3combat']['default_npc_type'] = 'Goon'
        DatabaseMigrator.write_config_file("fs3combat_npcs.yml", config)           

      end
    end
  end
end