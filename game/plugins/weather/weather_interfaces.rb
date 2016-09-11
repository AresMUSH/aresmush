module AresMUSH
  module Weather
    module Interface
      def self.weather_for_area(area)
        Weather.weather_for_area(area)
      end
    end
  end
end