module AresMUSH
  class WebApp    
    get '/map/:id/?' do |id|
      @map = GameMap[id]
      if (!@map)
        flash[:error] = "Map not found"
        redirect '/locations'
      end
      
      erb :"maps/map"
    end
  end
end
