module AresMUSH  

  module Migrations
    class MigrationBeta90Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Update engine keys."
        if (!Game.master.player_api_keys)
          Game.master.update(player_api_keys: {})
        end
        
        Global.logger.debug "Adding private roll shortcut."
        config = DatabaseMigrator.read_config_file("fs3skills_misc.yml")
        config['fs3skills']['shortcuts']['roll/secret'] = 'roll/private'
        DatabaseMigrator.write_config_file("fs3skills_misc.yml", config)
        
      end
    end    
  end
end