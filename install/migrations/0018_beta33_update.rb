module AresMUSH  
  module Migrations
    class MigrationBeta33Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding pm shortcut."

        config = DatabaseMigrator.read_config_file("page.yml")
        config['page']['shortcuts']['pm'] = 'page'
        DatabaseMigrator.write_config_file("page.yml", config)    

        config = DatabaseMigrator.read_config_file("jobs.yml")
        config['jobs']['shortcuts']['job/category'] = 'job/cat'
        DatabaseMigrator.write_config_file("jobs.yml", config)    
         
         
        
      end
    end
  end
end