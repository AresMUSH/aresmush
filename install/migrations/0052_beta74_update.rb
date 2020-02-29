module AresMUSH  

  module Migrations
    class MigrationBeta74Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add discord secret config."
        config = DatabaseMigrator.read_config_file("secrets.yml")
        if (!config['secrets']['discord'])
          config['secrets']['discord'] = {
            'api_token' =>  '',
            'webhooks' => []
          }
        end
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
        config['idle']['restrict_roster'] = false
        config['idle']['monthly_reminder_cron']['day'] = config['idle']['monthly_reminder_cron']['date']
        config['idle']['monthly_reminder_cron'].delete 'date'
        DatabaseMigrator.write_config_file("idle.yml", config)
        
        Global.logger.debug "Add job status filter config."
        config = DatabaseMigrator.read_config_file("jobs.yml")
        config['jobs']['status_filters'] = {}
        DatabaseMigrator.write_config_file("jobs.yml", config)
        
        Global.logger.debug "Set target defense skill."
        config = DatabaseMigrator.read_config_file("fs3combat_misc.yml")
        if (config['fs3combat']['combatant_types']['Target'])
          config['fs3combat']['combatant_types']['Target']['defense_skill'] = 1
        end
        DatabaseMigrator.write_config_file("fs3combat_misc.yml", config)
        
      end 
    end
  end
end