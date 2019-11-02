module AresMUSH  

  module Migrations
    class MigrationBeta67Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add CG system config."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['ability_system'] = 'fs3'
        config['chargen']['ability_system_app_review_header'] = 'Abilities (help abilities)'
        DatabaseMigrator.write_config_file("chargen.yml", config)

        Global.logger.debug "Add web tag color."
        config = DatabaseMigrator.read_config_file("describe.yml")
        config['describe']['tag_colors']['web'] = '%xh%xx'
        DatabaseMigrator.write_config_file("describe.yml", config)
        
        Global.logger.debug "Fixing game status."
        config = DatabaseMigrator.read_config_file("game.yml")
        if (!config['game']['status'])
          config['game']['status'] = config['game']['game_status'] || "In Development"
        end
        config['game'].delete 'game_status'
        DatabaseMigrator.write_config_file("game.yml", config)
        
        
        Global.logger.debug "Add profile backup commands."
        config = DatabaseMigrator.read_config_file("profile.yml")
        config['profile']['backup_commands'] = ["sheet", "bg", "profile", "damage", "relationships", "outfits/all"]
        DatabaseMigrator.write_config_file("profile.yml", config)
        
        
      end 
    end
  end
end