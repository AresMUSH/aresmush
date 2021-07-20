module AresMUSH  

  module Migrations
    class MigrationBeta99Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Removing weather from optional plugins."
        config = DatabaseMigrator.read_config_file("plugins.yml")
        config['plugins']['optional_plugins'].delete "weather"
        config['plugins']['config_help_links']['dice'] = 'https://github.com/AresMUSH/ares-dice-plugin'
        config['plugins']['config_help_links']['txt'] = 'https://github.com/SpiritLake/ares-txt-plugin'
        config['plugins']['config_help_links']['compliments'] = 'https://github.com/spiritlake/ares-compliments-plugin'
        config['plugins']['config_help_links']['eshtraits'] = 'https://github.com/ClockworkEJD/ares-eshtraits-plugin'
        config['plugins']['config_help_links']['weather'] = 'https://github.com/aresmush/ares-weather-plugin'
        DatabaseMigrator.write_config_file("plugins.yml", config)
      end
    end
  end    
end