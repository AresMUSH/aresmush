module AresMUSH  
  
  module Migrations
    class MigrationBeta40Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Adding locations shortcut."
        config = DatabaseMigrator.read_config_file("rooms.yml")
        config['rooms']['shortcuts']['rooms'] = 'room'
        config['rooms']['shortcuts']['locations'] = 'room'
        config['rooms']['shortcuts']['location'] = 'room'
        DatabaseMigrator.write_config_file("rooms.yml", config)    
  
        Global.logger.debug "Adding places marker config."
        config = DatabaseMigrator.read_config_file("jobs.yml")
        config['jobs']['shortcuts']['job/all'] = 'job/filter all'
        DatabaseMigrator.write_config_file("jobs.yml", config)    
      end
    end
  end
end