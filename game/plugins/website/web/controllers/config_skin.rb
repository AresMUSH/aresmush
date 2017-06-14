module AresMUSH
  class WebApp
    get '/admin/config_skin', :auth => :admin do
      
      @skin = Global.read_config("skin")      
      
      erb :"admin/config_skin"
    end
    
    post '/admin/config_skin/update', :auth => :admin do
      
      @skin = Global.read_config("skin")
      
      @skin['header'] =@params[:header]
      @skin['footer'] =@params[:footer]
      @skin['divider'] =@params[:divider]
      @skin['plain'] =@params[:plain]
      
      config = {
        'skin' => @skin
      }
      
      write_config_file File.join(AresMUSH.game_path, 'config', 'skin.yml'), config.to_yaml
      
      
      flash[:info] = "Saved!"
      Manage::Api.reload_config
      
      redirect '/admin'
    end
        
  end
end
