module AresMUSH  

  module Migrations
    class MigrationBeta74Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add discord secret config."
        config = DatabaseMigrator.read_config_file("secrets.yml")
        config['secrets']['discord'] = {
          'api_token' =>  '',
          'webhooks' => []
        }
        DatabaseMigrator.write_config_file("secrets.yml", config)
        
        Global.logger.debug "Add discord options."
        config = DatabaseMigrator.read_config_file("channels.yml")
        config['channels']['discord_prefix'] = '[D]'
        config['channels']['discord_gravatar_style'] = 'retro'
        DatabaseMigrator.write_config_file("channels.yml", config)
        
        Global.logger.debug "Add related scene fitler config."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['related_scenes_filter_days'] = 90
        DatabaseMigrator.write_config_file("scenes.yml", config)
        
        Global.logger.debug "Add roster app config."
        config = DatabaseMigrator.read_config_file("idle.yml")
        config['idle']['roster_app_template'] = "Tell us why you want to play this character:\n\n\nIf you're not submitting this from an existing character, provide an email where we can get back to you:"
        config['idle']['roster_app_category'] = 'APP'
        DatabaseMigrator.write_config_file("idle.yml", config)
        
      end 
    end
  end
end