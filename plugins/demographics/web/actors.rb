module AresMUSH
  class WebApp
    get '/actors/?' do
      @actors = Character.all.select { |c| !c.demographic(:actor).blank? }.map{ |c| [c.demographic(:actor), c.name ] }.to_h
      erb :"actors/actors_index"
    end    
  end
end