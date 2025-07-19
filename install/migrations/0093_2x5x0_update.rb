module AresMUSH  

  module Migrations
    class Migration2x5x0Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Installing default rainbow colors"
        src = File.join(AresMUSH.root_path, 'install', 'game.distr', 'styles', 'rainbow.scss')
        dest = File.join(AresMUSH.game_path, 'styles', 'rainbow.scss')
        FileUtils.cp src, dest
        
        Global.logger.debug "Installing default fonts"
        src = File.join(AresMUSH.root_path, 'install', 'game.distr', 'styles', 'fonts.scss')
        dest = File.join(AresMUSH.game_path, 'styles', 'fonts.scss')
        FileUtils.cp src, dest
      end
    end
  end    
end