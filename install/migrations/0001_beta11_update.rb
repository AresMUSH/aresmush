module AresMUSH
  module Migrations
    class MigrationBeta11Update
      def migrate
        puts "Adding weather configuration."
        
        default_weather = YAML::load( File.read(File.join(AresMUSH.root_path, "game.distr", "config", "weather.yml")))
        descriptions = default_weather["weather"]["descriptions"]
        
        weather_file = File.join(AresMUSH.root_path, "game", "config", "weather.yml")
        custom_weather = YAML::load( File.read( weather_file ))
        custom_weather["weather"]["descriptions"] = descriptions
        
        File.open(weather_file, 'w') do |f|
          f.write(custom_weather.to_yaml)
        end
        
        puts "Adding demographics help text."
        
        demo_file = File.join(AresMUSH.root_path, "game", "config", "demographics.yml")
        custom_demo = YAML::load( File.read( demo_file ))
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
        File.open(demo_file, 'w') do |f|
          f.write(custom_demo.to_yaml)
        end
        
      end
    end
  end
end