module AresMUSH
  module Migrations
    class MigrationBeta14Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Setting IC time names."
        
        config = DatabaseMigrator.read_config_file("ictime.yml")
        config['ictime']['month_names'] = []
        config['ictime']['day_names'] = []
        config['ictime']['game_start_date'] = ''
        config['ictime']['time_ratio'] = 1
        DatabaseMigrator.write_config_file("ictime.yml", config)
      end
    end
  end
end