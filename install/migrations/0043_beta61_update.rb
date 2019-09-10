module AresMUSH  

  module Migrations
    class MigrationBeta61Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Default roster welcome message."
        config = DatabaseMigrator.read_config_file("idle.yml")
        config['idle']['roster_arrival_msg'] = "%{name} has been claimed off the roster.\n\nPosition: %{position}\n\nRP Hooks:\n%{rp_hooks}"
        DatabaseMigrator.write_config_file("idle.yml", config)
        
        Global.logger.debug "Two word demo shortcuts."
        config = DatabaseMigrator.read_config_file("demographics.yml")
        config['demographics']['shortcuts']['fullname'] = 'demographic/set full name='
        config['demographics']['shortcuts']['playedby'] = 'demographic/set played by='          
        DatabaseMigrator.write_config_file("demographics.yml", config)
      end 
    end
  end
end