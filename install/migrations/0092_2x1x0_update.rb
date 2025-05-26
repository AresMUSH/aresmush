module AresMUSH  

  module Migrations
    class Migration2x1x0Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add web tour."
        if (!Global.read_config("login", "tour_not_allowed_message"))
          config = DatabaseMigrator.read_config_file("login.yml")
          config["login"]["allow_web_tour"] = true
          config["login"]["allow_game_tour"] = true
          config["login"]["tour_not_allowed_message"]  = ''
          config["login"]["allow_game_registration"] = config["login"]["allow_creation"]
          config["login"]["registration_not_allowed_message"] = config["login"]["creation_not_allowed_message"]
          config["login"]["temp_name_prefixes"] = Login.random_color_names
          config["login"]["temp_name_suffixes"] = Login.random_temp_names
          config["login"].delete "allow_creation"
          config["login"].delete "creation_not_allowed_message"
          config["login"].delete "random_guest_selection"
          config["login"].delete "guest_disabled_message"
          config["login"].delete "guest_role"
        
          DatabaseMigrator.write_config_file("login.yml", config)   
        end 

        Global.logger.debug "Remove guest role from idle config."
        idle_exempt_roles = Global.read_config("idle", "idle_exempt_roles") || []
        if (idle_exempt_roles.include?("guest"))
          config = DatabaseMigrator.read_config_file("idle.yml")
          config["idle"]["idle_exempt_roles"].delete "guest"
          DatabaseMigrator.write_config_file("idle.yml", config)    
        end

      end
    end
  end    
end