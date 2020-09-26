module AresMUSH  

  module Migrations
    class MigrationBeta85Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Shortcut for scene/mine."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config["scenes"]["shortcuts"]['scene/mine'] = 'scene/unshared'
        DatabaseMigrator.write_config_file("scenes.yml", config)

        Global.logger.debug "Adding traits chargen blurb."
        if (File.exists?(File.join(AresMUSH.game_path, "config", "traits.yml")))
          config = DatabaseMigrator.read_config_file("traits.yml")
          config["traits"]["traits_blurb"] = "Enter your character's traits."
          DatabaseMigrator.write_config_file("traits.yml", config)
        end
        
        Global.logger.debug "Adding scene pacing."
        Scene.all.each { |s| s.update(scene_pacing: "Traditional") }
      end
    end    
  end
end