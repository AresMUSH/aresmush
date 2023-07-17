module AresMUSH  

  module Migrations
    class Migration1x0x7Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Add disable login config."
        config = DatabaseMigrator.read_config_file("login.yml")
        config['login']['disable_nonadmin_logins'] = false
        DatabaseMigrator.write_config_file("login.yml", config)  
      end
    end
  end    
end