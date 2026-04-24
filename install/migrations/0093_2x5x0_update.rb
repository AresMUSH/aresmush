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
        
        Global.logger.debug "Adding submit_app permission"
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config["chargen"]["permissions"]["submit_app"] = "Can submit chargen application."
        DatabaseMigrator.write_config_file("chargen.yml", config)

        everyone_role = Role.find_one_by_name("everyone")
        everyone_role.add_permission "submit_app"        
      end
    end
  end    
end