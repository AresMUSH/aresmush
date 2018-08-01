module AresMUSH  
  module Migrations
    class MigrationBeta19Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding chat shortcut."
        config = DatabaseMigrator.read_config_file("channels.yml")
        config['channels']['shortcuts']['chat'] = 'channel'
        DatabaseMigrator.write_config_file("channels.yml", config)   
        
        Global.logger.debug "Adding notes shortcut."
        config = DatabaseMigrator.read_config_file("utils.yml")
        config['utils']['shortcuts']['notes'] = 'note'
        DatabaseMigrator.write_config_file("utils.yml", config)   
        
        Global.logger.debug "Moving notes to player section."
        Character.all.each do |c|
          notes = c.notes || {}
          new_notes = { player: notes }
          c.update(notes: new_notes)
        end
        
        Global.logger.debug "Adding achievements to optional plugins."
        config = DatabaseMigrator.read_config_file("plugins.yml")
        config['plugins']['optional_plugins'] << "achievements"
        DatabaseMigrator.write_config_file("plugins.yml", config)   
        
        Global.logger.debug "Adding achievements config."
        default_achievements = DatabaseMigrator.read_distr_config_file("achievements.yml")
        DatabaseMigrator.write_config_file("achievements.yml", default_achievements)
      end
    end
  end
end