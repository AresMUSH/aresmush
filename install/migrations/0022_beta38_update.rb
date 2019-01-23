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
        config['scenes']['ooc_lounge_channel'] = ''
        DatabaseMigrator.write_config_file("scenes.yml", config)    
  
        Global.logger.debug "Adding places marker config."
        config = DatabaseMigrator.read_config_file("places.yml")
        config['places']['start_marker'] = "["
        config['places']['end_marker'] = "]"
        DatabaseMigrator.write_config_file("places.yml", config)    
  
        Global.logger.debug "Moving portal requires registration."
        config = DatabaseMigrator.read_config_file("website.yml")
        require_reg = config['website']['portal_requires_registration']
        config['website'].delete 'portal_requires_registration'
        DatabaseMigrator.write_config_file("website.yml", config)    
        
        config = DatabaseMigrator.read_config_file("login.yml")
        config['login']['portal_requires_registration'] = require_reg
        config['login']['guest_disabled_message'] = ""
        DatabaseMigrator.write_config_file("login.yml", config)    
    
        Global.logger.debug "Setting share date on scenes."
        Scene.all.each do |s|
          if (s.shared && !s.date_shared)
            s.update(date_shared: s.created_at)
          end
        end
        
        Global.logger.debug "Setting quiet room."
        quiet_room = Room.find_one_by_name("Quiet Room")
        if (quiet_room)
          Game.master.update(quiet_room: quiet_room)
        else
          Global.logger.warn "Quiet room not found."
        end
      end
    end
  end
end