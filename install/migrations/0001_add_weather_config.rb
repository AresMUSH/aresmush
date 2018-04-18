module AresMUSH
  module Migrations
    class MigrationAddWeatherConfig
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
      end
    end
  end
end