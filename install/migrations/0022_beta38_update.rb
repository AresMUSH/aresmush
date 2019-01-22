module AresMUSH  
  
  module Migrations
    class MigrationBeta38Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Installing default notification."
        src = File.join(AresMUSH.root_path, "install", "game.distr", "uploads", "theme_images", "notification.png")
        dest = File.join(AresMUSH.game_path, "uploads", "theme_images", "notification.png")
        FileUtils.cp src, dest
        
        Global.logger.debug "Adding trending scenes config."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['trending_scenes_category'] = "Cookie Awards"
        config['scenes']['trending_scenes_cron'] = { 'hour' => [19], 'minute' => [15], 'day_of_week' => [ 'Mon' ] }
        DatabaseMigrator.write_config_file("scenes.yml", config)    
  
        Global.logger.debug "Adding places marker config."
        config = DatabaseMigrator.read_config_file("places.yml")
        config['places']['start_marker'] = "["
        config['places']['end_marker'] = "]"
        DatabaseMigrator.write_config_file("places.yml", config)    
  
  
        Global.logger.debug "Setting share date on scenes."
        Scene.all.each do |s|
          if (s.shared && !s.date_shared)
            s.update(date_shared: s.created_at)
          end
        end
      end
    end
  end
end