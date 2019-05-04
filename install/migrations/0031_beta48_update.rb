module AresMUSH  
  module Migrations
    class MigrationBeta48Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "New page config."
        config = DatabaseMigrator.read_config_file("page.yml")
        config['page']['unread_page_deletion_days'] = 14
        config['page']['unread_page_deletion_cron'] = { 'day_of_week' => ['Sun'], 'hour' => [03], 'minute' => [40] }
        DatabaseMigrator.write_config_file("page.yml", config)  
        
      end
    end
  end
end
