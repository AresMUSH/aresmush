module AresMUSH
  module Migrations
    class MigrationBeta11Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding weather configuration."
        
        default_weather = DatabaseMigrator.read_distr_config_file("weather.yml")
        descriptions = default_weather["weather"]["descriptions"]
        
        custom_weather = DatabaseMigrator.read_config_file("weather.yml")
        custom_weather["weather"]["descriptions"] = descriptions
        
        DatabaseMigrator.write_config_file("weather.yml", custom_weather)
        
        Global.logger.debug "Adding demographics help text."
        
        custom_demo = DatabaseMigrator.read_config_file("demographics.yml")
        
        custom_demo["demographics"]["disable_auto_shortcuts"] = false
        custom_demo["demographics"]["help_text"] = {
          "actor" => "See 'help actors'.",
          "physique" => "Build/body type - athletic, wiry, slim, pudgy, etc.",
          "gender" => "Male/Female/Other",
          "hair" => "Hair color",
          "eyes" => "Eye color",
          "skin" => "Complexion",
          "birthdate" => "Specify a date mm/dd/yyyy or use %xcage <years>.%xn",
          "callsign" => "Callsign for pilots.  Non-pilots may leave blank or enter a nickname."
        }
        custom_demo["demographics"]["shortcuts"] = {
          "groups" => "group",
          "colonies" => "group colony",
          "demographics" => "demographic"
        }
        DatabaseMigrator.write_config_file("demographics.yml", custom_demo)
      end
    end
  end
end