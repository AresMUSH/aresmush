module AresMUSH  

  module Migrations
    class MigrationBeta61Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Default roster welcome message."
        config = DatabaseMigrator.read_config_file("idle.yml")
        config['idle']['roster_arrival_msg'] = "%{name} has been claimed off the roster.\n\nPosition: %{position}\n\nRP Hooks:\n%{rp_hooks}"
        config = DatabaseMigrator.write_config_file("idle.yml", config)
      end 
    end
  end
end