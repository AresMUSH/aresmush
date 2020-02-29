module AresMUSH
  module Weather
    class WeatherConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("weather")
      end
      
      def validate
        @validator.require_hash('climate_for_area')
        @validator.require_hash('climates')
        @validator.require_list('conditions')
        @validator.require_nonblank_text('default_climate')
        @validator.require_hash('descriptions')
        @validator.require_list('temperatures')
        @validator.check_cron('weather_cron')
        
        begin
          climates = Global.read_config('weather', 'climates')
          Global.read_config('weather', 'climate_for_area').each do |area, clime|
            if (clime != 'none' && !climates.has_key?(clime))
              @validator.add_error "weather:climate_for_area #{area} has an invalid climate."
            end
          end
          default = Global.read_config('weather', 'default_climate')
          if (default != 'none' && !climates.has_key?(default))
            @validator.add_error "weather:default_climate is an invalid climate."
          end
          descs = Global.read_config('weather', 'descriptions')
          Global.read_config('weather', 'conditions').each do |c|
            if (!descs.has_key?(c))
              @validator.add_error "weather:descriptions missing desc for #{c} condition."
            end
          end
          Global.read_config('weather', 'temperatures').each do |temp|
            ['spring', 'summer', 'fall', 'winter'].each do |season|
              ['morning', 'day', 'evening', 'night'].each do |time|
                key = "#{temp}_#{season}_#{time}"
                if (!descs.has_key?(key))
                  @validator.add_error "weather:descriptions missing desc for #{key}."
                end
              end
            end
          end
          
        rescue Exception => ex
          @validator.add_error "Unknown weather config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0]}"
          
        end
        
        @validator.errors
      end

    end
  end
end