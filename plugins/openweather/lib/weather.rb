module AresMUSH
   module Openweather
     # Look up current weather conditions by available api calls
     #   all methods return parsed json response objects
     class Weather
       VERSION = '2.5'
       BASE_URL = 'http://api.openweathermap.org/data/'
       attr_accessor :version, :api_key, :units

       def initialize(api_key = nil)
         @api_key = api_key
         @version = VERSION
       end

       def by_zip_code(zip_code, country = 'us')
         run(zip: "#{zip_code},#{country}")
       end

       def by_city_id(city_id)
         run(id: city_id)
       end

       def by_coords(latitude, longitude)
         run(lat: latitude, lon: longitude)
       end
      
       private

       def run(params)
         fail ArgumentError, 'Missing api key' unless @api_key
         params[:appid] = @api_key
         params[:units] = @units if @units
	 response = Net::HTTP.get_response(url(params))
	 WeatherResponse.new(response.body)
       end

       def url(params)
	       URI.parse("#{BASE_URL}#{version}/weather?" + params_to_string(params))
       end

       def params_to_string(params)
         params.map { |key, value| "#{key}=#{value}" }.join('&')
       end
     end
   end
end
