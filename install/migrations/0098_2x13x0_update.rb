module AresMUSH  

  module Migrations
    class Migration2x13x0Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Guest cleanup."
        config = DatabaseMigrator.read_config_file("login.yml")
        config['login']['idle_guest_days'] = 7
        config['login']['cleanup_guests_cron'] = { 'day_of_week' => ["Tue"], 'hour' => [02], 'minute' => [14] }
        DatabaseMigrator.write_config_file("login.yml", config)
      end
    end
  end    
end