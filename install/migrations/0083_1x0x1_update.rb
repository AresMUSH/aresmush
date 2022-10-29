module AresMUSH  

  module Migrations
    class Migration1x0x1Update
      def require_restart
        true
      end
      
      def migrate

        Global.logger.debug "Game config file rewrite."
        config = DatabaseMigrator.read_config_file("game.yml")
        game_keys = {}
        config['game'].each do |k, v|
          game_keys[k] = v
        end
        config['game'] = game_keys
        DatabaseMigrator.write_config_file("game.yml", config)     
      end
    end
  end    
end