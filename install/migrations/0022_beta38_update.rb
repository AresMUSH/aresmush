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
        
      end
    end
  end
end