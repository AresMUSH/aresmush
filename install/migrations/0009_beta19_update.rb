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
        
      end
    end
  end
end