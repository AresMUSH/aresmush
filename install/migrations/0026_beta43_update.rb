module AresMUSH  
  module Migrations
    class MigrationBeta43Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Splitting dots after chargen."
        old_dots = Global.read_config('fs3skills', 'dots_beyond_chargen_max')
        config = DatabaseMigrator.read_config_file("fs3skills_xp.yml")
        config['fs3skills']['attr_dots_beyond_chargen_max'] = old_dots
        config['fs3skills']['action_dots_beyond_chargen_max'] = old_dots
        DatabaseMigrator.write_config_file("fs3skills_xp.yml", config)  

        Global.logger.debug "Add help links."
        config = DatabaseMigrator.read_config_file("plugins.yml")
        config['plugins']['config_help_links'] = 
        {
          'ffg' => 'https://github.com/AresMUSH/ares-extras/tree/master/plugins/ffg',
          'fate' => 'https://github.com/AresMUSH/ares-extras/tree/master/plugins/fate',
          'cortex' => 'https://github.com/AresMUSH/ares-extras/tree/master/plugins/cortex',
          'prefs' => 'https://github.com/AresMUSH/ares-extras/tree/master/plugins/prefs',
          'traits' => 'https://github.com/AresMUSH/ares-extras/tree/master/plugins/traits'
        }
        DatabaseMigrator.write_config_file("plugins.yml", config)  
        
        map_config = File.join(AresMUSH.game_path, "config", "maps.yml")
        if (File.exist?(map_config))
          File.delete(map_config)
        end
      end
    end
  end
end
