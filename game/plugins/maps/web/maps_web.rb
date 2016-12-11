module AresMUSH
  class WebApp
    get '/maps' do
      @maps = Maps.available_maps
      erb :maps_index
    end
    
    get '/map/edit/:name' do |name|
      map_file = AresMUSH::Maps.get_map_file(name)
      @map = AresMUSH::Maps.load_map(map_file)
      @name = name
      erb :map_edit
    end
    
    get '/map/show/:name' do |name|
      map_file = AresMUSH::Maps.get_map_file(name)
      @map = AresMUSH::Maps.load_map(map_file)
      @name = name
      erb :map_show
    end
    
    post '/map/update/:name' do |name|
      map_file = AresMUSH::Maps.get_map_file(name)
      AresMUSH::Maps.save_map(map_file, params[:map])
      redirect "/map/show/#{name}"
    end
  end
end
