module AresMUSH  

  module Migrations
    class MigrationBeta67Update
      def require_restart
        true
      end
      
      def migrate
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
        
        Global.logger.debug "Add char card option."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['use_custom_char_cards'] = false
        DatabaseMigrator.write_config_file("scenes.yml", config)
        
        Global.logger.debug "Add plugin extras list."
        config = DatabaseMigrator.read_config_file("plugins.yml")
        config['plugins']['extras'] = []
        config['plugins']['command_queue_limit'] = 15
        DatabaseMigrator.write_config_file("plugins.yml", config)
      end 
    end
  end
end