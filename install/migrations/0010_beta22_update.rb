module AresMUSH  
  module Migrations
    class MigrationBeta22Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Removing chat shortcut."
        config = DatabaseMigrator.read_config_file("channels.yml")
        config['channels']['shortcuts'].delete('chat')
        DatabaseMigrator.write_config_file("channels.yml", config)   
        
        
        Global.logger.debug "Default channels to show titles."
        ChannelOptions.all.each do |c|
          c.update(show_titles: true)
        end
        
      end
    end
  end
end