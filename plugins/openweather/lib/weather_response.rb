module AresMUSH
   module Openweather
     # Wrapper class to hold the json response from api endpoint
     #  includes methods that interact on the response
     class WeatherResponse
       attr_accessor :weather

       def initialize(weather)
         @weather = JSON.parse(weather, symbolize_names: true)
       end

       def coords
         {
           latitude: weather[:coord][:lat],
           longitude: weather[:coord][:lon]
         }
       end

       def temperature
         weather[:main][:temp]
       end

       def pressure
         weather[:main][:pressure]
       end

       def humidity
         weather[:main][:humidity]
       end

       def temperature_range
         [weather[:main][:temp_min], weather[:main][:temp_max]]
       end

       def wind
         weather[:wind]
       end

       def cloudy?
         !weather[:clouds].nil? && weather[:clouds][:all] > 0
       end

       def clouds
         return 0 if weather[:clouds].nil?
         weather[:clouds][:all]
       end

       def rainy?
         !weather[:rain].nil? && weather[:rain][:'3h'] > 0
       end

       def rain
         return 0 unless rainy?
         weather[:rain][:'3h']
       end

       def snowy?
         !weather[:snow].nil? && weather[:snow][:'3h'] > 0
       end

       def snow
         return 0 unless snowy?
         weather[:snow][:'3h']
       end

       def sunrise
         weather[:sys][:sunrise]
       end

       def sunset
         weather[:sys][:sunset]
       end
     end
   end
end
