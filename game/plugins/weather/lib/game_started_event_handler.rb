module AresMUSH
  module Weather
    class WeatherGameStartedEventHandler
       def on_event(event) 
         Weather.current_weather = {}
         Weather.change_all_weathers
       end
     end
  end
end