module AresMUSH
  class Game
    attribute :engine_api_key
  end
  
  module Migrations
    class MigrationBeta18Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Moving API Key to secrets config file."
        config = DatabaseMigrator.read_config_file("secrets.yml")
        config['secrets']['engine_api_keys'] = [ SecureRandom.uuid ]
        DatabaseMigrator.write_config_file("secrets.yml", config)        
        Game.master.update(engine_api_key: nil)
        
        Global.logger.debug "Adding nickname field."
        config = DatabaseMigrator.read_config_file("demographics.yml")
        config['demographics']['nickname_field'] = ""
        config['demographics']['nickname_format'] = "%{name} (%{nickname})"
        DatabaseMigrator.write_config_file("demographics.yml", config)     
        
        Global.logger.debug "Adding clear history cron job."
        config = DatabaseMigrator.read_config_file("channels.yml")
        config['channels']['clear_history_cron'] = { 'hour' => [4], 'minute' => [47] }
        DatabaseMigrator.write_config_file("channels.yml", config)   
        
        
        Global.logger.debug "Adding idle desc to rooms."
        config = DatabaseMigrator.read_config_file("describe.yml")
        config['describe']['always_show_idle_in_rooms'] = false
        DatabaseMigrator.write_config_file("describe.yml", config)   
        
          
        
      end
    end
  end
end