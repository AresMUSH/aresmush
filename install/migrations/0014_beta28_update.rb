module AresMUSH  
  module Migrations
    class MigrationBeta28Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding scene timeout."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['idle_scene_timeout_days'] = 3
        DatabaseMigrator.write_config_file("scenes.yml", config)    
        
        Global.logger.debug "Adding posebreak shortcut."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['shortcuts']['posebreak'] = 'autospace'
        DatabaseMigrator.write_config_file("scenes.yml", config)    
        
        Global.logger.debug "Adding server SSL and bind options."
        config = DatabaseMigrator.read_config_file("server.yml")
        config['server']['private_key_file_path'] = ''
        config['server']['certificate_file_path'] = ''
        config['server']['use_https'] = false
        config['server']['bind_address'] = ''
        DatabaseMigrator.write_config_file("server.yml", config)  
        
          
        Global.logger.debug "Login permissions."
        config = DatabaseMigrator.read_config_file("login.yml")
        config['login']['allow_creation'] = true
        config['login']['login_not_allowed_message'] = ''
        config['login']['creation_not_allowed_message'] = ''
        config['login']['shortcuts']['pcreate'] = 'create/reserve'
        DatabaseMigrator.write_config_file("login.yml", config)  
        everyone_role = Role.find_one_by_name("everyone")
        everyone_role.add_permission "login"
      end
    end
  end
end