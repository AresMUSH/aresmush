module AresMUSH
    module Openweather
      class OpenweatherGameStartedEventHandler
         def on_event(event)
           Openweather.current_weather = {}
           Openweather.change_all_weathers
         end
       end
    end
  end