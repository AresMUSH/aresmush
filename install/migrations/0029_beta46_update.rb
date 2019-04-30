module AresMUSH  
  module Migrations
    class MigrationBeta46Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Adding request filter shortcuts."
        config = DatabaseMigrator.read_config_file("jobs.yml")
        config['jobs']['shortcuts']['request/all'] = 'request/filter all'
        config['jobs']['shortcuts']['request/active'] = 'request/filter active'
        DatabaseMigrator.write_config_file("jobs.yml", config)  
        
        Global.logger.debug "Converting fansi flag to color mode."
        Character.all.each { |c| c.update(color_mode: c.fansi_on ? "FANSI" : "ANSI") }
        
        config = DatabaseMigrator.read_config_file("utils.yml")
        config['utils']['shortcuts']['colors'] = 'color'

        DatabaseMigrator.write_config_file("utils.yml", config)  
        
      end
    end
  end
end
