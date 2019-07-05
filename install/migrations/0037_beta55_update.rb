module AresMUSH  

  module Migrations
    class MigrationBeta55Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Fixing advantage XP name."
        config = DatabaseMigrator.read_config_file("fs3skills_xp.yml")
        if (!config['fs3skills']['xp_costs'].has_key?('advantage'))
          config['fs3skills']['xp_costs']['advantage'] = config['fs3skills']['xp_costs']['advantages']
          config['fs3skills']['xp_costs'].delete('advantages')
        end
        DatabaseMigrator.write_config_file("fs3skills_xp.yml", config)
       
      
      end 
    end
  end
end