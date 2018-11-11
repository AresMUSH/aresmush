module AresMUSH  
  module Migrations
    class MigrationBeta30Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding birthday shortcut."
        config = DatabaseMigrator.read_config_file("demographics.yml")
        config['demographics']['shortcuts']['birthday'] = 'birthdate'
        DatabaseMigrator.write_config_file("demographics.yml", config)    
        
        
        Global.logger.debug "Fixing welcome message board."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['arrivals_category'] = Global.read_config("chargen", "arrivals_board")
        config['chargen'].delete "arrivals_board"
        DatabaseMigrator.write_config_file("chargen.yml", config)   
      end
    end
  end
end