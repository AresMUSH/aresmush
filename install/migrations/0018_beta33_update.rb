module AresMUSH  
  module Migrations
    class MigrationBeta33Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding pm shortcut and page markers."
        config = DatabaseMigrator.read_config_file("page.yml")
        config['page']['shortcuts']['pm'] = 'page'
        config['page']['page_start_marker'] = '<'
        config['page']['page_end_marker'] = '>'
        DatabaseMigrator.write_config_file("page.yml", config)    

        Global.logger.debug "Adding glance format."
        default_config = DatabaseMigrator.read_distr_config_file("describe.yml")
        config = DatabaseMigrator.read_config_file("describe.yml")
        config['describe']['glance_format'] = default_config['describe']['glance_format']
        DatabaseMigrator.write_config_file("describe.yml", config)    

        Global.logger.debug "Adding job category shortcut."
        config = DatabaseMigrator.read_config_file("jobs.yml")
        config['jobs']['shortcuts']['job/category'] = 'job/cat'
        DatabaseMigrator.write_config_file("jobs.yml", config)    
         
        Global.logger.debug "Adding whisper shortcuts."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['shortcuts']['whisp'] = 'whisper'
        config['scenes']['shortcuts']['mutter'] = 'whisper'
        config['scenes']['shortcuts'].delete 'whisper'        
        DatabaseMigrator.write_config_file("scenes.yml", config)    
      end
    end
  end
end