module AresMUSH  

  module Migrations
    class MigrationBeta85Update
      def require_restart
        false
      end
      
      def migrate
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config["scenes"]["shortcuts"]['scene/mine'] = 'scene/unshared'
        DatabaseMigrator.write_config_file("scenes.yml", config)
        
        if (File.exists?(File.join(AresMUSH.game_path, "config", "traits.yml")))
          config = DatabaseMigrator.read_config_file("traits.yml")
          config["traits"]["traits_blurb"] = "Enter your character's traits."
          DatabaseMigrator.write_config_file("traits.yml", config)
        end
      end
    end    
  end
end