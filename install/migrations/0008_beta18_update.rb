module AresMUSH
  class Game
    attribute :engine_api_key
  end
  
  module Migrations
    class MigrationBeta18Update
      def require_restart
        true
      end
      
      def migrate
        
        Global.logger.debug "Moving API Key to secrets config file."
        config = DatabaseMigrator.read_config_file("secrets.yml")
        config['secrets']['engine_api_keys'] = [ SecureRandom.uuid ]
        DatabaseMigrator.write_config_file("secrets.yml", config)        
        Game.master.update(engine_api_key: nil)
        
      end
    end
  end
end