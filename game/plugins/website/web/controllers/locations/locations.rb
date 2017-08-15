module AresMUSH
  class WebApp
    get '/locations/?' do
      @areas = Room.all.group_by { |r| r.area }
      erb :"locations/locations_index"
    end
    
    get '/location/:id/?' do |id|
      @room = Room[id]
      if (!@room)
        flash[:error] = "Location not found."
        redirect '/locations'
      end
      
      erb :"locations/detail"
    end
  end
end
