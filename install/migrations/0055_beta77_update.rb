module AresMUSH  

  module Migrations
    class MigrationBeta77Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding notice shortcut."
        config = DatabaseMigrator.read_config_file("login.yml")
        shortcuts = config['login']['shortcuts']
        shortcuts.delete 'motd'
        shortcuts['notice'] = 'notices'
        config['login']['shortcuts'] = shortcuts
        DatabaseMigrator.write_config_file("login.yml", config)
        
        Global.logger.debug "Updating timestamps on login notices"
        LoginNotice.all.each { |n| n.update(timestamp: n.created_at)}
      end 
    end
  end
end