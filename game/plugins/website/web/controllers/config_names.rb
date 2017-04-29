module AresMUSH
  class WebApp
    get '/admin/config_names', :auth => :admin do
      @names = Global.read_config("names")
      
      erb :"admin/config_names"
    end
    
    post '/admin/config_names/update', :auth => :admin do
      
      @names = Global.read_config("names")
     
      @names['restricted'] = @params[:restricted_names].split("\r\n").map { |n| n.downcase }
      config = {
        'names' => @names
      }
      write_config_file File.join(AresMUSH.game_path, 'config', 'names.yml'), config.to_yaml
      
      
      flash[:info] = "Saved!"
      Manage::Api.reload_config
      
      redirect '/admin'
    end
        
  end
end
