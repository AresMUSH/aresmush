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
          config["login"]["tour_welcome_message"] = "Welcome to our game. We hope you enjoy your stay.\n\nYour temporary name is %{name} and password is %{password}\n\nIf you wish to keep this character, you can rename them and change their password. See `help tour` for details. Otherwise, just log out and the character will be recycled." 
          config["login"].delete "allow_creation"
          config["login"].delete "creation_not_allowed_message"
          config["login"].delete "random_guest_selection"
          config["login"].delete "guest_disabled_message"
          config["login"].delete "guest_role"
        
          DatabaseMigrator.write_config_file("login.yml", config)   
        end 
        
        Global.logger.debug "Add guest names."
        prefix = [ "Aqua", "Violet", "Ruby", "Ivory", "Teal", "Gold", "Copper", "Silver", "Mint", "Forest" ]
        suffix = [ "Guest", "Visitor", "Wanderer", "Wayfarer", "Traveler" ]
        
        names = []
        prefix.each do |p|
          suffix.each do |s| 
            names << "#{p}#{s}"
          end
        end
        
        if (!Global.read_config("names", "guest"))
          config = DatabaseMigrator.read_config_file("names.yml")
          config["names"]["guest"] = names.sort
          DatabaseMigrator.write_config_file("names.yml", config)   
          
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